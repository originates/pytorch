import itertools
import os
import time
from typing import List

import numpy as np
import tabulate
import torch
import torch.distributed as dist
import torch.fx as fx
import torch.multiprocessing as mp
import torch.nn as nn
import torch.optim as optim
from torch.nn.parallel import DistributedDataParallel as DDP
from torch.profiler import ProfilerActivity
from torch.profiler import profile
from torch.profiler import record_function
from torch.utils._python_dispatch import TorchDispatchLogger
import torchdynamo
from torchdynamo.optimizations import BACKENDS

from torch._ops import OpTracker

if __name__ == "__main__":
    with OpTracker() as tr:
        class ToyModel(nn.Module):
            def __init__(self):
                super(ToyModel, self).__init__()
                self.net = nn.Sequential(
                    nn.Linear(10, 10000),
                    nn.ReLU(),
                    nn.Linear(10000, 10000),
                    nn.ReLU(),
                    nn.Linear(10000, 1000),
                    nn.ReLU(),
                    nn.Linear(1000, 1000),
                    nn.ReLU(),
                    nn.Linear(1000, 5),
                )

            def forward(self, x):
                return self.net(x)

        m = ToyModel()
        inputs = torch.randn(200)
        inputs = inputs.reshape(20,10)
        m(inputs)
    print(tr.ops())
