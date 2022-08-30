#!/usr/bin/env bash



red='\033[1;31m'
green='\033[1;32m'
blue='\033[1;33m'
yellow='\033[1;33m'
reset='\033[0m'

STD_OUT="&>/dev/null"
STD_ERR="2>/dev/null"


tools=~/Tools
subdomains_list=$tools/sub_brute_small.txt
GOTATOR_TIMEOUT="timeout 100"

banner(){
printf "\n${green}"
printf " ______                     _                    \n"
printf " | ___ \                   (_)                   \n"
printf " | |_/ /___  ___ ___  _ __  _ _______ _ __       \n"
printf " |    // _ \/ __/ _ \| '_ \| |_  / _ \ '__|      \n"
printf " | |\ \  __/ (_| (_) | | | | |/ /  __/ |         \n"
printf " \_| \_\___|\___\___/|_| |_|_/___\___|_|         \n"
printf "                                                 \n${reset}"
}


start()
{
	dir=$PWD/Recon/$domain
	mkdir -p $dir
	cd $dir
	mkdir -p .tmp/
	tools=~/Tools
	tools_installed
	printf "\n${green}##########################################################################${reset}"
	printf "\n${red}Target: $domain ${reset}\n"
}


tools_installed()
{
	printf "${yellow} Checking the installation of tools${reset}\n"
	printf "${green}###########################################################################${reset}\n"
	[ -f $tools/ctfr/ctfr.py ] && printf "${green} [*] ctfr.py [YES]${reset}\n" || printf "${bred} [*] ctfr.py [NO]${reset}\n"
	[ -f $tools/dnsvalidator/dnsvalidator/dnsvalidator.py ] && printf "${green} [*] dnsvalidator [YES]${reset}\n" || printf "${bred} [*] dnsvalidator [NO]${reset}\n"
	[ -f $tools/dorks_hunter/dorks_hunter.py ] && printf "${green} [*] dorks_hunter [YES]${reset}\n" || printf "${bred} [*] dorks_hunter [NO]${reset}\n"




	eval type -P amass $STD_OUT && printf "${green} [*] Amass [YES]${reset}\n" || printf "${red} [*] Amass [NO]${reset}\n"
	eval type -P subfinder $STD_OUT && printf "${green} [*] Subfinder [YES]${reset}\n" || printf "${red} [*] Subfinder [NO]${reset}\n"
	eval type -P findomain $STD_OUT && printf "${green} [*] Findomain [YES]${reset}\n" || printf "${red} [*] Findomain [NO]${reset}\n"
	eval type -P assetfinder $STD_OUT && printf "${green} [*] assetfinder [YES]${reset}\n" || printf "${red} [*] assetfinder [NO]${reset}\n"
	eval type -P gau $STD_OUT && printf "${green} [*] Gau [YES]${reset}\n" || printf "${red} [*] Gau [NO]${reset}\n"
	eval type -P massdns $STD_OUT && printf "${green} [*] Massdns [YES]${reset}\n" || printf "${red} [*] Massdns [NO]${reset}\n"
	eval type -P puredns $STD_OUT && printf "${green} [*] Puredns [YES]${reset}\n" || printf "${red} [*] Puredns [NO]${reset}\n"
	eval type -P gotator $STD_OUT && printf "${green} [*] Gotator [YES]${reset}\n" || printf "${red} [*] Gotator [NO]${reset}\n"
	eval type -P httpx $STD_OUT && printf "${green} [*] Httpx [YES]${reset}\n" || printf "${red} [*] Httpx [NO]${reset}\n"
	eval type -P gospider $STD_OUT && printf "${green} [*] Gospider [YES]${reset}\n" || printf "${red} [*] Gospider [NO]${reset}\n"
	eval type -P unfurl $STD_OUT && printf "${green} [*] Unfurl [YES]${reset}\n" || printf "${red} [*] Unfurl [NO]${reset}\n"
	eval type -P analyticsrelationships $STD_OUT && printf "${green} [*] Analyticsrelationships [YES]${reset}\n" || printf "${red} [*] Analyticsrelationships [NO]${reset}\n"
	eval type -P nuclei $STD_OUT && printf "${green} [*] Nuclei [YES]${reset}\n" || printf "${red} [*] Nuclei [NO]${reset}\n"
	eval type -P gowitness $STD_OUT && printf "${green} [*] Gowitness [YES]${reset}\n" || printf "${red} [*] Gowitness [NO]${reset}\n"


	printf "${green}##############################################################################${reset}\n\n"
}



######################################## OSINT Section ###########################################

osint_init()
{
	mkdir -p OSINT/
	printf "${green}##############################################################################${reset}\n\n"
	printf "${green}Starting OSINT Enumeration${reset}\n"
}

google_dorks()
{
	printf "${green}##############################################################################${reset}\n\n"
	printf "${yellow}Google Dorking Started${reset}\n\n"
	python3 $tools/dorks_hunter/dorks_hunter.py -d $domain -o OSINT/dorks.txt
}

github_dorks()
{
	printf "${green}##############################################################################${reset}\n\n"
	printf "${yellow}Github Dorking Started${reset}\n\n"
	gitdorks_go -gd $tools/gitdorks_go/Dorks/medium_dorks.txt -nws 15 -target $domain -tf $tools/.github_tokens -ew 3 | anew -q OSINT/gitdorks.txt
	
}

email_osint()
{
	printf "${green}##############################################################################${reset}\n\n"
	printf "${yellow}Email OSINT Started${reset}\n"
	emailfinder -d $domain > .tmp/tmp_emailfinder.txt
	[ -s ".tmp/tmp_emailfinder.txt" ] && cat .tmp/tmp_emailfinder.txt | awk 'matched; /^--------------/ { matched = 1 }' | anew -q OSINT/emails.txt
	
}

osint_end()
{
	printf "${green}OSINT Enumeration Ended${reset}\n"
	printf "${green}##############################################################################${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}

######################################## Subdomian Enumeration ###########################################


subdomain_init()
{
	mkdir -p subdomains/
	printf "${green}##############################################################################${reset}\n"
	printf "${green}Starting Subdomain Enumeration${reset}\n"
}

subdomain_passive()
{
	printf "${green}##############################################################################${reset}\n\n"
	printf "${yellow}Passive Enumeration Started${reset}\n\n"
	eval subfinder -d $domain -all -config /root/.config/subfinder/config.yaml -o .tmp/passive_subfinder.txt $STD_OUT
	eval assetfinder --subs-only $domain | anew -q .tmp/passive_assetfinder.txt $STD_OUT
	eval findomain -t $domain -u .tmp/passive_findomain.txt $STD_OUT
	eval amass enum -passive -d $domain -config /root/.config/amass/config.ini -o .tmp/passive_amass.txt $STD_OUT
	eval github-subdomains -d $domain -t $tools/.github_tokens -o .tmp/passive_github_subdomains.txt $STD_OUT
	eval timeout 100 gau --subs $domain --o .tmp/gau_tmp.txt $STD_OUT
	cat .tmp/gau_tmp.txt | unfurl -u domains | grep ".$domain$" | anew -q .tmp/passive_gau.txt

	Number_of_lines=$(find .tmp -type f -iname "passive*" -exec cat {} \; | sed "s/*.//" | anew .tmp/passive_subs.txt | wc -l)
	printf "${green}Found!!: $Total_subs new subdomains${reset}\n\n"
	printf "${yellow}Passive Enumeration Ended${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}

subdomain_crt()
{
	printf "${yellow}Certficate Transparency Enumeration Started${reset}\n\n"
	eval python3 $tools/ctfr/ctfr.py -d $domain -o .tmp/crtsh_subs_tmp.txt $STD_OUT
	Number_of_lines=$(cat .tmp/crtsh_subs_tmp.txt | anew .tmp/crtsh_subs.txt | wc -l)
	printf "${green}Found!!: $Number_of_lines new subdomains ${reset}\n\n"
	printf "${yellow}Certficate Transparency Enumeration Ended${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}

subdomain_active()
{
	printf "${yellow}Active Subdomain Enumeration Started${reset}\n\n"
	cat .tmp/passive_subs.txt .tmp/crtsh_subs.txt | anew -q .tmp/subs_to_resolve.txt
	eval puredns resolve .tmp/subs_to_resolve.txt -w .tmp/subs_valid.txt -r $tools/resolvers.txt --resolvers-trusted $tools/resolvers_trusted.txt $STD_OUT
	Number_of_lines=$(cat .tmp/subs_valid.txt | grep ".$domain$" | anew subdomains/subdomains.txt | wc -l)
	printf "${green}Found!!: $Number_of_lines valid subdomains ${reset}\n\n"
	printf "${yellow}Active Subdomain Enumeration Ended${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}

subdomain_bruteforcing()
{
	printf "${yellow}Subdomain Bruteforcing Started${reset}\n\n"
	eval puredns bruteforce $subdomains_list $domain -w .tmp/subs_brute_valid.txt -r $tools/resolvers.txt --resolvers-trusted $tools/resolvers_trusted.txt $STD_OUT 
	Number_of_lines=$(cat .tmp/subs_brute_valid.txt |  grep ".$domain$" | anew subdomains/subdomains.txt | wc -l)
	printf "${green}Found!!: $Number_of_lines new subdomains ${reset}\n\n"
	printf "${yellow}Subdomain Bruteforcing Ended${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}

subdomain_permutations()
{
	printf "${yellow}Subdomain Permutations started${reset}\n\n"
	eval $GOTATOR_TIMEOUT gotator -sub subdomains/subdomains.txt -perm $tools/permutation_list.txt -depth 1 -numbers 10 -mindup -adv -md -silent > .tmp/gotator_out.txt $STD_OUT
	eval puredns resolve .tmp/gotator_out.txt -w .tmp/permutations_valid.txt -r $tools/resolvers.txt --resolvers-trusted $tools/resolvers_trusted.txt $STD_OUT
	Number_of_lines=$(cat .tmp/permutations_valid.txt | grep ".$domains$" | anew subdomains/subdomains.txt | wc -l)
	#eval rm -rf .tmp/gotator_out.txt $STD_OUT
	printf "${green}Found!!: $Number_of_lines new subdomains ${reset}\n\n"
	printf "${yellow}Subdomain Permutations Ended${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}

subdomian_scraping()
{
	printf "${yellow}Subdomain Scraping started${reset}\n\n"
	eval cat subdomains/subdomains.txt | httpx -retries 2 -timeout 10 -o .tmp/scrap_probed.txt $STD_OUT
	eval gospider -S .tmp/scrap_probed.txt --js -d 2 --sitemap --robots -w -r > .tmp/gospider.txt
	sed -i '/^.\{2048\}./d' .tmp/gospider.txt
	eval cat .tmp/gospider.txt | grep -aEo 'https?://[^ ]+' | sed 's/]$//' | unfurl -u domains | grep ".$domain$" | anew -q .tmp/scrap_subs_no_resolved.txt $STD_OUT
	eval puredns resolve .tmp/scrap_subs_no_resolved.txt -w .tmp/scrap_valid.txt -r $tools/resolvers.txt --resolvers-trusted $tools/resolvers_trusted.txt $STD_OUT
	Number_of_lines=$(cat .tmp/scrap_valid.txt | grep ".$domain$" | anew subdomains/subdomains.txt | wc -l)
	printf "${green}Found!!: $Number_of_lines new subdomains ${reset}\n\n"
	printf "${yellow}Subdomain Scraping Ended${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}

subdomain_analytics()
{
	printf "${yellow}Subdomain Analytics Enumeration started${reset}\n\n"
	eval cat .tmp/scrap_probed.txt | analyticsrelationships -ch >> .tmp/analytics_subs_tmp.txt $STD_OUT
	[ -s ".tmp/analytics_subs_tmp.txt" ] && cat .tmp/analytics_subs_tmp.txt | grep ".$domain$" | anew .tmp/analytics_subs.txt $STD_OUT
	Number_of_lines=$(cat .tmp/analytics_subs.txt | anew subdomains/subdomains.txt | wc -l)
	printf "${green}Found!!: $Number_of_lines new subdomains ${reset}\n\n"
	printf "${yellow}Subdomain Analytics Enumeration Ended${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}

subdomain_takeover()
{
	printf "${yellow}Subdomain Takeover Detection started${reset}\n\n"
	eval nuclei -update-templates $DEBUG_STD
	eval cat subdomains/subdomains.txt | nuclei -silent -tags takeover -severity low,medium,high,critical -r $tools/resolvers_trusted.txt -retries 3 -o .tmp/sub_takeover.txt $STD_OUT
	Number_of_lines=$(cat .tmp/sub_takeover.txt | anew subdomains/takeovers.txt | wc -l)
	printf "${green}Found!!: $Number_of_lines subdomain takeovers${reset}\n\n"
	printf "${yellow}Subdomain Takeover Detection Ended${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}

web_probing()
{
	mkdir -p web/
	printf "${yellow}Web probing started${reset}\n\n"
	eval cat sudomains/subdomains.txt | httpx -retries 2 -timeout 10 -o .tmp/web_probed_tmp.txt $STD_OUT
	Number_of_lines=$(cat .tmp/web_probed_tmp.txt | anew web/webs.txt  | wc -l )
	printf "${green}Found!!: $Number_of_lines New Websites${reset}\n\n"
	printf "${yellow}Web probing Ended${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}

web_screenshot()
{
	printf "${yellow}Web screenshots Started${reset}\n\n"
	eval gowitness file -f web/webs.txt -t 8 --disable-logging $STD_OUT
	printf "${yellow}Web screenshots Ended${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}

nuclei()
{
	mkdir -p nuclei_output/
	printf "${yellow}Nuclei Vulnerability Scanning Started${reset}\n\n"
	nuclei -severity info -silent -t ~/nuclei-templates/ -retries 2 -o nuclei_output/info.txt
	nuclei -severity low -silent -t ~/nuclei-templates/ -retries 2 -o nuclei_output/low.txt
	nuclei -severity medium -silent -t ~/nuclei-templates/ -retries 2 -o nuclei_output/medium.txt
	nuclei -severity high -silent -t ~/nuclei-templates/ -retries 2 -o nuclei_output/high.txt
	nuclei -severity critical -o nuclei_output/critical.txt
	printf "${yellow}Nuclei Vulnerability Scanning Ended${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}

help()
{	
	printf "Reconizer is a all-in-one Reconnaisance tool that performs\n"
	printf "subdomain using various techniques that guarantee the best results.\n"
	printf "Usage: $0 [-d domain] [-o] [-s]\n"
	printf "${blue}TARGET OPTIONS${reset}\n"
	printf "	-d example.com  Target Domain\n\n"
	printf "${blue}SCAN MODES${reset}\n"
	printf "	-n OSINT Scan\n"
	printf "	-s Subdomain Scan\n\n"
	printf "${blue}OUTPUT OPTIONS${reset}\n"
	printf "	-o Output Folder\n\n"
	printf "${blue}SHOW HELP SECTION${reset}\n"
	printf "	-h Display help section\n\n"
	printf "${blue}USAGE EXAMPLE${reset}\n"
	printf "OSINT Scan:\n"
	printf "./reconizer.sh -d example.com -n\n\n"
	printf "Subdomain Enumeration Scan:\n"
	printf "./reconizer.sh -d example.com -s\n\n"
	printf "Custom Output Folder Location:\n"
	printf "./reconizer.sh -d example.com -s -o /path/to/folder\n\n"
	printf "${green}##########################################################################${reset}\n"
}



banner


if [ -z "$1" ]
then
   help
   exit
fi


while getopts ":d:o:snhc" opt;do
	case ${opt} in
		d ) domain=$OPTARG
			;;
		n )
			start
			osint_init
			google_dorks
			github_dorks
			email_osint
			osint_end
			;;
		s )
			start
			subdomain_init
			subdomain_passive
			subdomain_crt
			subdomain_active
			subdomain_bruteforcing
			subdomain_permutations
			subdomian_scraping
			subdomain_analytics
			subdomain_takeover
			web_probing
			web_screenshot
			nuclei
			;;
		o ) output_folder=$OPTARG
			;;
		c )
			tools_installed
			;;
		\? | h | : | * )
			help
			;;
	esac
done
shift $((OPTIND -1))


