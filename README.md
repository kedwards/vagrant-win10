# Vagrant Win10

A windows 10 vagrant box, can be built manually or automagically.

## Manual

```
./prepare.sh
```

log in and configure..

## Automatic

```
./run.sh
```

edit Autounattended file..


### Iniitializing the vagrant environment

```
vagrant init
```

### Clear out certificates

```
xfreerdp /u:vagrant /p:vagrant /v:127.0.0.1:3389
```

### Start VM

```
vagrant up
```

### login

```
vagrant rdp -- /smart-sizing
```