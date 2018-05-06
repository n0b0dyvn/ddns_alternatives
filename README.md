# DDNS Alternatives

This project is created because I want a solution that can update Public IP without using ugly subdomain of NO-IP service.

## Version

|Version| Status |
|---------------------------------------------------------------------------------------------------------------------------------------|--|
|0.0.1*                                                                                                                                   |  - Poorly bash code without any configuration file |
|0.0.2| - Add configuration file | 
|0.0.3| - Use other language and make program looks professional.

*-current version


## How to use
1. Replace your own information in file. Include API key, your cloudflare login,domain, subdomain,etc.
2. Create a crontab to use it scheduly.
> */5 * * * * bash ddns.sh
