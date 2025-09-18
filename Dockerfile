ARG BASE_IMAGE=inseefrlab/onyxia-vscode-python
FROM $BASE_IMAGE

LABEL maintainer="Matthieu Doutreligne <matthieu.doutreligne@insee.fr>"

USER root

COPY --chmod=0755 scripts/ /opt/

# Install VSCode
RUN /opt/install-terminal-utils.sh && \
    /opt/install-vscode-extensions.sh

# set zsh as default shell
#FIXME: this does not seem  to work when creating a new terminal in VSCode
RUN chsh -s $(which zsh)

USER 1000