#!/usr/bin/env bash
echo "Checking for missing software ..."
if command -v kubectl >/dev/null 2>&1; then
    echo "OK kubectl"
else
    echo "ERROR make sure you have kubectl installed"
    return 1
fi
if command -v docker >/dev/null 2>&1; then
    echo "OK docker"
    if id -nG "$USER" | grep -qw "docker"; then
        echo "OK docker rootless"
    else
        echo "ERROR user '$USER' does not belong to 'docker' group"
        return 1
    fi
    if (! pgrep -f docker >/dev/null); then
        echo "WARN docker daemon is not running, do you like to start it? (Y/N)"
        read answer
        if [[ $answer == 'Y' || $answer == 'y' ]]; then
            sudo systemctl start docker.service
            if [ $? -eq 0 ]; then
                echo "OK docker daemon is $(systemctl is-active docker)"
            else
                echo "ERROR docker daemon is not running"
                return 1
            fi
        else
            echo "ERROR docker daemon is not running"
            return 1
        fi
    else
        echo "OK docker daemon is $(systemctl is-active docker)"
    fi
else
    echo "ERROR make sure you have docker installed"
    return 1
fi
if command -v minikube >/dev/null 2>&1; then
    echo "OK minikube"
else
    echo "ERROR make sure you have minikube installed"
    exit 1
fi
exit 0