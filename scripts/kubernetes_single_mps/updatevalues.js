/*********************************************************************
* Copyright (c) Intel Corporation 2020
* SPDX-License-Identifier: Apache-2.0
**********************************************************************/
var fs = require('fs');

let envPath = `.env`;
let helmfilepath = "./serversChart/values.yaml";

var endOfLine = require('os').EOL;

if (fs.existsSync(envPath)) {
    if (fs.existsSync(helmfilepath)) {
        var envFile = fs.readFileSync(envPath).toString().split(endOfLine);
        let helmFile = fs.readFileSync(helmfilepath).toString().split(endOfLine);	
		
		
		for(j in helmFile){
            let helmLine = helmFile[j];            
            //console.log(`helmLine: ${helmLine}`);

            for(i in envFile){
                let envLine = envFile[i];
                //console.log(`envLine: ${envLine}`);

                var firstLocation = envLine.indexOf('=');
			
                //console.log(`firstlocation: ${firstLocation}`);
                
                if(firstLocation !== -1){
                    let key =  envLine.substr(0, firstLocation);
                    let value = envLine.substr(firstLocation + 1).trim();

                    //console.log(`key: ${key}, value: ${value}`);

                    helmLine = helmLine.replace(key, value);

                    //console.log(`updated helm line: ${helmLine}`);
                    helmFile[j] = helmLine;
                    
                }
                // else{
                //     console.log(`no = found`);
                // }
            }			
        }
       
	   console.log(`updated helm file`);
       fs.writeFileSync(helmfilepath, helmFile.join(endOfLine));

    } else {
        console.log(`${helmfilepath} doesn't exist`);
    }

} else {
    console.log(`${envPath} doesn't exist`);
}
