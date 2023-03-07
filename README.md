# DIA Development Toolkit

A toolkit for simulate the DIA oracle locally. [Wiki](https://github.com/alexjorgef/diatestsuite/wiki) contains the documentation on how-to use it.

## Structure

```
.
├── build                                    Custom container's definitions
├── deployments
│   ├── config                               Config files needed for initialize cluster containers
│   ├── k8s-yaml                             Deployment's definitions
│   ├── helm
│   │   └── dia                              Helmchart for development
│   ├── init.sh                              Script for initialize local cluster
│   ├── start.sh                             Script for start containers
│   └── stop.sh                              Script for stop containers
└── minikube.log                             Cluster log
```