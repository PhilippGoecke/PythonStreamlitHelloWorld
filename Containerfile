FROM docker.io/python:3.13-slim

RUN apt update \
  && apt install -y build-essential curl software-properties-common git python3-pip pipx \
  && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash streamlit \
  && mkdir /app \
  &&chown streamlit /app
USER streamlit
WORKDIR /app

RUN pipx install poetry
ENV PATH $PATH:/home/streamlit/.local/bin
RUN poetry --version

#RUN poetry init \
RUN poetry new /app \
  && poetry config virtualenvs.in-project true \
  && poetry add streamlit \
  && poetry env list \
  && poetry config --list

RUN ls -lisah /app

RUN echo '\
import streamlit as st\n\
\n\
if "username" in st.query_params:\n\
        st.title("Hello " + st.query_params["username"])\n\
else:\n\
        st.title("Hello World")\n\
\n\
st.write("Learn [Streamlit](https://streamlit.io/)")\n\
' > app/main.py

EXPOSE 8085

HEALTHCHECK CMD curl --fail http://localhost:8085/_stcore/health

#ENTRYPOINT ["poetry", "run", "streamlit", "hello", "--server.port=8085", "--server.address=0.0.0.0"]
ENTRYPOINT ["poetry", "run", "streamlit", "run", "app/main.py", "--server.port=8085", "--server.address=0.0.0.0"]

