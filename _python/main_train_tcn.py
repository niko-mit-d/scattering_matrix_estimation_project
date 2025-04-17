from torch.nn import Sequential, Conv1d, BatchNorm1d, ReLU
import torch.nn as nn
import torch
import torch.optim as optim
from torch.utils.data import DataLoader, TensorDataset
from pathlib import Path
import numpy as np

import os

def main():
    print("hi")

    model = TCN()

    measurements = load_npy_data()
    sequences, targets = prepare_data(measurements)  # Convert your data to numpy first  
    dataset = TensorDataset(sequences, targets)
    dataloader = DataLoader(dataset, batch_size=32, shuffle=True)

    train_tcn(model, dataloader)
    return

def load_npy_data():
    file_name = "SMatrix.npy"
    source_path = Path("_python/simulation_data/5part/totalmodes3")

    Smatrix_paths = list(source_path.rglob(file_name))
    all_measurments = [scattering_matrix_to_states(np.load(Smatrix_path)) for Smatrix_path in Smatrix_paths]

    combined_xk = np.concatenate(all_measurments, axis=0)
    for measurement in all_measurments:
        measurement = np.transpose(measurement, (1, 2, 0))
        # convert to state space

    print(combined_xk.shape)
    return Smatrix_paths


def scattering_matrix_to_states(measurement):
    dim_S = 3
    n = 18
    xk = np.zeros((n, measurement.shape[2]))

    idx = 0
    for k in range(dim_S):
        for j in range(k, dim_S):
            xk[idx, :] = np.real(measurement[k, j, :])
            xk[idx + n // 2, :] = np.imag(measurement[k, j, :])
            idx += 1
    
    return xk


# ------ TCN Block (Dilated Causal Conv + Residual) ------
class TCNBlock(nn.Module):
    def __init__(self, in_channels, out_channels, kernel_size, dilation):
        super().__init__()
        self.conv = nn.Conv1d(
            in_channels, 
            out_channels, 
            kernel_size, 
            padding="same",  # Auto-pad to maintain length
            dilation=dilation
        )
        self.bn = nn.BatchNorm1d(out_channels)
        self.relu = nn.ReLU()
        self.downsample = nn.Conv1d(in_channels, out_channels, 1) if in_channels != out_channels else None

    def forward(self, x):
        residual = x
        out = self.relu(self.bn(self.conv(x)))
        if self.downsample is not None:
            residual = self.downsample(residual)
        return out + residual  # Residual connection


# ------ Full TCN Model ------
class TCN(nn.Module):
    def __init__(self, input_dim=18, output_dim=18, hidden_dim=64, kernel_size=3, num_blocks=3):
        super().__init__()
        self.blocks = nn.ModuleList([
            TCNBlock(
                in_channels=input_dim if i == 0 else hidden_dim,
                out_channels=hidden_dim,
                kernel_size=kernel_size,
                dilation=2 ** i  # Exponential dilation: 1, 2, 4, ...
            ) 
            for i in range(num_blocks)
        ])
        self.fc = nn.Linear(hidden_dim, output_dim)

    def forward(self, x):
        # x shape: (batch_size, seq_len, input_dim)
        x = x.permute(0, 2, 1)  # -> (batch_size, input_dim, seq_len)
        for block in self.blocks:
            x = block(x)
        x = x.permute(0, 2, 1)  # -> (batch_size, seq_len, hidden_dim)
        return self.fc(x[:, -1, :])  # Predict next step (output_dim)

# ------ Training Loop ------
def train_tcn(model, dataloader, epochs=100, lr=1e-3):
    criterion = nn.MSELoss()
    optimizer = optim.Adam(model.parameters(), lr=lr)
    
    for epoch in range(epochs):
        for batch_seq, batch_target in dataloader:
            optimizer.zero_grad()
            pred = model(batch_seq)
            loss = criterion(pred, batch_target)
            loss.backward()
            optimizer.step()
        print(f"Epoch {epoch+1}, Loss: {loss.item():.4f}")

# ------ Data Preparation ------
def prepare_data(data, seq_len=50):
    # data shape: (num_measurements, total_steps, state_dim)
    sequences, targets = [], []
    for measurement in data:
        for i in range(len(measurement) - seq_len):
            sequences.append(measurement[i:i+seq_len])
            targets.append(measurement[i+seq_len])
    return torch.stack(sequences), torch.stack(targets)


if __name__ == "__main__":
    main()