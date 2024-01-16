{ config, pkgs, ... }: { 
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDqsazlhOhBl2bmUbvnsLLYeuLBfVrLsfOt5nv3FKw9Nui1y7PmiTacU+CEDex3gLAA6KLP8a+o4uPH1y16L/ZJhADqc6cuYcnFIyMWgsO2TfFz5SUmsgSFN3FUZuJ1aMdp+hz0o2pUZIwKVAy/LwvPzvWmTlcgyQOBMWKqD/lm+KKSAV87OcnRhdhDj2/36QxDVI+5dG5yQJ0xR7mcmUxADEtrkH1ONM7a4M+or9T7285+zlXwsxkGDTKHCULHx0gfaUP5Xph4WfHFcmbKWZ+RygUWYHC/I8xHfvP4EFvPIZfv8jppysDx9sLpMsUiLylbkJ298L+Grq/H6QYc/QZG6LDF0dzqgxpAzKWjOeYBiUZ2HQ9nHNDZiWsQb6+Ai8MnRC0irPXFvYkMooNj+9JEZ5LXnm7WA4/Z99wz0Ucd3cYTazpB+H+BkK07wdecsXIC0C/bTsVo4wUSGkrezRv6Im6Mxp4Ag90FDaW3d0OmOQhiXaMsoa1p3LhT+F1zY+c= nrb@nixos"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDf+wIUgLHwwb19+b8siWPnQMiHSA0Vj/C8jGVvCWUa2 root@vps-6ec22220"
  ];
}