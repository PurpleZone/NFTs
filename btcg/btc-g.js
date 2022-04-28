// script to update dynamic logo parts
 const symb = 'btc-g';
 const ticker = 'btcg';
 const gw = 'https://ipfs.safewatch.care';
 const immutable = 'QmXg18831o6mizuSeBpDEU7WZcpegVLdNd3goQYm6tB17S';
 let path = 'https://raw.githubusercontent.com/PurpleZone/NFTs/'+ticker
     path = location.pathname.replace(/\/[^/]*$/,'');
     path = gw+'/ipfs/'+immutable;
 console.log('path:',path);
 fetch(path+`/${symb}.json`).then(resp => resp.json()).
   then(cfg => {
   console.log('cfg:',cfg);
   document.getElementById('clickable').addEventListener('click',
        function() { location.href = path+'/factsheet.html'; }
        );
     if (typeof(cfg.name) != 'undefined') {
       document.getElementById('co2weight').innerHTML = `${cfg.fprint}`;
     }
     return cfg;
   }).
   catch(console.error);

