$ip = Read-Host "Please enter your IP Address"
((Get-Content ./mps/.mpsrc) -replace('"common_name":.*"',('"common_name": "' + $ip + '"'))) | Set-Content ./mps/.mpsrc
((Get-Content ./sample-web-ui/src/environments/environment.ts) -replace('mpsServer:.*',('mpsServer: "https://' + $ip + ':3000",'))) | Set-Content ./sample-web-ui/src/environments/environment.ts
((Get-Content ./sample-web-ui/src/environments/environment.ts) -replace('rpsServer:.*',('rpsServer: "https://' + $ip + ':8081",'))) | Set-Content ./sample-web-ui/src/environments/environment.ts

cd ./mps
npm install
cd ../rps
npm install
cd ../sample-web-ui
npm install
cd ..