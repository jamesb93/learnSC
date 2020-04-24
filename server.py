import argparse
import sys
import os
import numpy as np
import umap
import struct

from sklearn.preprocessing import StandardScaler, MinMaxScaler
from pythonosc import dispatcher
from pythonosc import osc_server
from pythonosc import udp_client
from typing import List, Any

class DimensionReducer():

    def __init__(self):  
        self.files = []
        self.data = []
        self.tmp_data = []

    @staticmethod
    def kill_server(unused_addr, *args):
        os._exit(1)

    def clear_tmp(self, unused_addr, *args):
        self.tmp_data = []

    def form_arr(self, unused_addr, *args):
        self.tmp_data.append(args[0])

    def add_feature(self, unused_addr, *args):
        self.data.append(self.tmp_data)
        print(self.data)
        
    def dim_reduction(self, unused_addr, *args):
        scaler = StandardScaler()
        scaler.fit(self.data)
        self.data = scaler.transform(self.data)

        self.embedding = umap.UMAP(
            n_components=2,
            min_dist=0.3,
            metric='correlation'
        )
        
        embedding.fit(data)
        self.data = embedding.transform(self.data)

        # Renormalise the data so that the values sit nicely on a grid.
        minmax = MinMaxScaler()
        minimax.fit(self.data)
        self.data = minmax.transform(self.data)

        self.data = self.data.transpose().tolist()
        for x, y, names in zip(self.data[0], self.data[1], self.files): 
            self.client.send_message('/data', [names, x, y])
            # self.client.send_message('/y', self.pca_data_transposed_aslist[1])
            # self.client.send_message('/x', self.pca_data_transposed_aslist[0])
            # self.client.send_message('/names', )



if __name__ == "__main__":
    process = DimensionReducer()
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--ip",
        default="127.0.0.1", 
        help="The ip to listen on"
    )
    parser.add_argument(
        "--port",
        type=int, 
        default=40000, 
        help="The port to listen on"
    )
    args = parser.parse_args()

    dispatcher = dispatcher.Dispatcher()
    dispatcher.map("/kill", process.kill_server)
    dispatcher.map("/reduce", process.dim_reduction)
    dispatcher.map("/add", process.add_feature)
    dispatcher.map("/insert", process.form_arr)
    dispatcher.map("/clear", process.clear_tmp)

    server = osc_server.ThreadingOSCUDPServer((args.ip, args.port), dispatcher)
    client = udp_client.SimpleUDPClient(args.ip, 57120)
    print('OSC Server Live')
    client.send_message('/status', 'OSC Server Loaded')
    server.serve_forever()