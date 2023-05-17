dockerfile="build/Dockerfile-DiadataBuild"
dockerfile_117="build/Dockerfile-DiadataBuild-117"
imageName="build"
imageName_117="build-117"
type="devops"
version="v1.4.1"
build_and_push() {
        docker build -f "build/$1" -t "diadata.$2" .
        docker tag "diadata.$2" "us.icr.io/dia-registry/$3/$2:latest"
        docker tag "diadata.$2" "us.icr.io/dia-registry/$3/$2:$version"
        if [ "$notpush" != "true" ]; then
                docker push "us.icr.io/dia-registry/$3/$2:latest"
                docker push "us.icr.io/dia-registry/$3/$2:$version"
        fi
}
if [[ "$*" != *"--notpush"* ]]; then
    notpush="false"
else
    notpush="true"
fi
build_and_push "$dockerfile" "$imageName" "$type"
build_and_push "$dockerfile_117" "$imageName_117" "$type"