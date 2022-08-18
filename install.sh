#!/usr/bin/env bash

red='\033[1;31m'
green='\033[1;32m'
blue='\033[1;33m'
yellow='\033[1;33m'
reset='\033[0m'

STD_OUT="&>/dev/null"
STD_ERR="2>/dev/null"


shell_profile=.$(basename $(which $SHELL))rc
mkdir -p /root/Tools
tools=~/Tools
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"


apt_installer()
{
	printf "${yellow}##################################################################${reset}\n\n"
	printf "${green}Installing system packages ${reset}\n\n"
	eval apt-get update -y $STD_OUT
	eval DEBIAN_FRONTEND="noninteractive" apt install python3 python3-pip build-essential gcc cmake ruby unzip whois git curl libpcap-dev wget zip python3-dev pv dnsutils libssl-dev libffi-dev libxml2-dev libxslt1-dev zlib1g-dev nmap jq apt-transport-https lynx tor medusa xvfb libxml2-utils procps bsdmainutils libdata-hexdump-perl -y $STD_OUT
}


go_installation()
{
	printf "${yellow}##################################################################${reset}\n\n"
	printf "${green}Installing & Setting up Go-lang enviornment ${reset}\n\n"
	version=$(curl -s -L https://go.dev/VERSION?m=text)
	eval wget https://go.dev/dl/$version.linux-amd64.tar.gz $STD_OUT
	eval rm -rf /usr/local/go && tar -C /usr/local -xzf $version.linux-amd64.tar.gz
	eval ln -sf /usr/local/go/bin/go /usr/local/bin/

}


go_tools()
{
	printf "${yellow}##################################################################${reset}\n\n"
	printf "${green}Installing Go-lang tools${reset}\n\n"
	eval go install -v github.com/tomnomnom/anew@latest $STD_OUT
	eval go install -v github.com/damit5/gitdorks_go@latest $STD_OUT
	eval go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest $STD_OUT
	eval go install github.com/tomnomnom/assetfinder@latest $STD_OUT
	eval go install -v github.com/OWASP/Amass/v3/...@master $STD_OUT
	eval go install -v github.com/lc/gau/v2/cmd/gau@latest $STD_OUT
	eval go install github.com/d3mondev/puredns/v2@latest $STD_OUT
	eval go install -v github.com/Josue87/gotator@latest $STD_OUT
	eval go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest $STD_OUT
	eval go install -v github.com/jaeles-project/gospider@latest $STD_OUT
	eval go install -v github.com/tomnomnom/unfurl@latest $STD_OUT
	eval go install -v github.com/Josue87/analyticsrelationships@latest $STD_OUT
	eval go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest $STD_OUT

	export GOROOT=/usr/local/go
    export GOPATH=$HOME/go
    export PATH=$GOPATH/bin:$GOROOT/bin:$HOME/.local/bin:$PATH

    source ~/.bashrc $STD_OUT
	source ~/.zshrc $STD_OUT
}


install_requirements()
{
	printf "${yellow}##################################################################${reset}\n\n"
	printf "${green}Installing Python requirements packages${reset}\n\n"
	eval pip3 install -I -r requirements.txt $STD_OUT
}



install_repos()
{
	printf "${yellow}##################################################################${reset}\n\n"
	printf "${green}Download Python Repositories${reset}\n\n"
	eval git clone https://github.com/six2dez/dorks_hunter $tools/dorks_hunter $STD_OUT
	eval git clone https://github.com/UnaPibaGeek/ctfr $tools/ctfr $STD_OUT
	eval git clone https://github.com/vortexau/dnsvalidator $tools/dnsvalidator $STD_OUT
	eval git clone https://github.com/blechschmidt/massdns.git $tools/massdns $STD_OUT
	eval git clone https://github.com/projectdiscovery/nuclei-templates ~/nuclei-templates $STD_OUT

}

install_misc()
{
	 printf "${yellow}##################################################################${reset}\n\n"
	 printf "${green}Performing some miscellaneous tasks${reset}\n\n"
	 wget https://github.com/Findomain/Findomain/releases/download/8.2.0/findomain-linux.zip
	 unzip findomain-linux.zip
	 mv findomain /usr/local/bin/findomain
	 chmod 755 /usr/local/bin/findomain
	 cd $tools/massdns
	 make
	 sudo make install
	 cd $SCRIPTPATH
	 subfinder
	 touch $tools/.github_tokens
	 wget -q -O - https://wordlists-cdn.assetnote.io/data/manual/best-dns-wordlist.txt > $tools/sub_brute_large.text
	 wget -q -O - https://gist.githubusercontent.com/jhaddix/86a06c5dc309d08580a018c66354a056/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt > $tools/sub_brute_small.txt
	 wget -q -O - https://gist.githubusercontent.com/sidxparab/94a231f058b277d995f800c0174a5744/raw/02d621d317b0161ac0d7278fa8bd0c7fb710ba6c/resolvers_trusted.txt > $tools/resolvers_trusted.txt
	 wget -q -O - https://gist.githubusercontent.com/sidxparab/b5cf037265d376a7fdf2a5a9abac9764/raw/5dd6f19242da0de984dab02b90920edeb07621f0/permutation_list.txt > $tools/permutation_list.txt
	 mkdir -p ~/.config/amass/
	 [ ! -f ~/.config/amass/config.ini ] && wget -q -O ~/.config/amass/config.ini https://raw.githubusercontent.com/OWASP/Amass/master/examples/config.ini
	 mkdir -p ~/.config/nuclei/

}

create_resolvers()
{
	printf ""
	cd $tools/dnsvalidator
	eval python3 setup.py install $STD_OUT
	cd $SCRIPTPATH
	eval dnsvalidator -tL https://raw.githubusercontent.com/trickest/resolvers/main/resolvers.txt -threads 200 -o $tools/resolvers.txt $STD_OUT
}


apt_installer
go_installation

#configuring go enviornment
cat << EOF >> $HOME/$shell_profile
# Golang vars
export GOROOT=/usr/local/go
export GOPATH=\$HOME/go
export PATH=\$GOPATH/bin:\$GOROOT/bin:\$HOME/.local/bin:\$PATH
EOF

go_tools
install_requirements
install_repos
install_misc
create_resolvers
