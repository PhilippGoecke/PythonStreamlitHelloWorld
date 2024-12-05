podman build --no-cache --rm -f Containerfile -t streamlit:demo .
podman run --interactive --tty -p 8585:8085 streamlit:demo
echo "browse http://localhost:8585/?username=Test"
