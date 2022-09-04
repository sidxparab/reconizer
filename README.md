<h1 align="center">
  <br>
  <a href="https://github.com/sidxparab/reconizer"><img src="https://github.com/sidxparab/reconizer/blob/main/Images/reconizer_banner.png" alt="reconizer"></a>
  <br>
  Recoznier
  <br>
</h1>


<p align="center">
  <a href="https://twitter.com/sidxparab">
    <img src="https://img.shields.io/badge/twitter-sidxparab-blue">
  </a>
  <a href="https://sidxparab.gitbook.io/subdomain-enumeration-guide/">
    <img src="https://img.shields.io/badge/doc-GitBook-orange">
  </a>
</p>


<h3 align="center">Summary</h3>

**Reconizer** is a all-in-one subdomain enumeration tool which automates the subdomain enumeration process for you using the various subdomain enumeration techniques.


📔 Table of Contents
-----------------
- [Installation:](#-installation)
- [Usage:](#usage)
- [Example Usage:](#example-usage)
- [:fire: Features :fire:](#fire-features-fire)
  - [Osint](#osint)
  - [Subdomains](#subdomains)
- [Features to be added:](#features-to-be-added)
- [Still Need help? :information_source:](#still-need-help-information_source)

---

# Installation:

## Install all tool at once

Simply Git clone the script and run the installer script.

```bash
git clone https://github.com/sidxparab/reconizer
cd reconizer/
./install.sh
./reconizer -h
```


# Usage:

**TARGET OPTIONS**

| Flag | Description |
|------|-------------|
| -d | Specify the target domain   |
| -c | Check for Installed tools |
| -n | Run OSINT mode  |
| -s | Run Subdomain Enumeration Mode |
| -a | Axiom Subdomain Scan |
| -f | All scan (OSINT+Subdomain) |
| -h | Show help section |


# Example Usage:

**Perform OSINT scan**

```bash
./reconizer.sh -d target.com -n
```

**Perform subdomain enumeration**

```bash
./reconftw.sh -d target.com -r
```

**Perform Full scan**

```bash
./reconftw.sh -d target.com -f
```

**Perform Axiom subdomain enumeration**

```bash
./reconftw.sh -d target.com -a
```

**Show help section**

```bash
./reconizer.sh -h
```

# :fire: Features :fire:

 ## Osint
- Google Dorks ([dorks_hunter](https://github.com/six2dez/dorks_hunter))
- Github Dorks ([gitdorks_go](https://github.com/damit5/gitdorks_go))
- Email Finder  ([emailfinder](https://github.com/Josue87/EmailFinder))

## Subdomains
  - Passive ([subfinder](https://github.com/projectdiscovery/subfinder), [assetfinder](https://github.com/tomnomnom/assetfinder), [findomain](https://github.com/Findomain/Findomain), [amass](https://github.com/OWASP/Amass), [github-subdomains](https://github.com/gwen001/github-subdomains) and [gau](https://github.com/lc/gau))
  - Certificate transparency ([ctfr](https://github.com/UnaPibaGeek/ctfr))
  - Bruteforce ([puredns](https://github.com/d3mondev/puredns))
  - Permutations ([Gotator](https://github.com/Josue87/gotator))
  - JS files & Source Code Scraping ([gospider](https://github.com/jaeles-project/gospider))
  - Google Analytics ID ([AnalyticsRelationships](https://github.com/Josue87/AnalyticsRelationships))
  - Subdomains takeover ([nuclei](https://github.com/projectdiscovery/nuclei))

## Webs
- Web Prober ([httpx](https://github.com/projectdiscovery/httpx))
- Web screenshot ([gowitness](https://github.com/sensepost/gowitness))
- Web templates scanner ([nuclei](https://github.com/projectdiscovery/nuclei))



## Still Need help? :information_source:

-  Contact me in [Twitter](https://twitter.com/sidxparab)

