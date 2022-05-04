// script to update dynamic logo parts
 const symb = 'btc-g';
 const ticker = 'btcg';
 const gw = 'https://ipfs.safewatch.care';
 const immutable = 'QmXg18831o6mizuSeBpDEU7WZcpegVLdNd3goQYm6tB17S';
 const mutable = 'QmUs6X2QHrPSAW9mZYtHGNCDjMDWTk7cg3EiEQ1Ao4PvL9';
 let path = 'https://raw.githubusercontent.com/PurpleZone/NFTs/'+ticker
     path = 'https://cdn.jsdelivr.net/gh/PurpleZone/NFTs@latest/'+ticker
     //path = gw+'/ipfs/'+immutable;
     //path = gw+'/ipns/'+mutable;
     path = location.pathname.replace(/\/[^/]*$/,'');
 console.log('path:',path);
 fetch(path+`/${symb}.json`).then(resp => resp.json()).
   then(cfg => {
   console.log('cfg:',cfg);
   document.getElementById('clickable').addEventListener('click',
        function() { location.href = path+'/factsheet.html'; }
        );
     let p = 100.0;
     if (typeof(cfg.level) != 'undefined') {
       p =  parseFloat(cfg.level.replace('%$',''));
       console.log('p:',p+'%');
       let y =  68 + 13 * p / 100;
       console.log('y:',y);
       document.getElementById('gauge').setAttribute('y',y);
       console.log('levelid:',document.getElementById('gauge'));
     }
     if (typeof(cfg.footprint) != 'undefined') {
       let co2 = parseFloat(cfg.footprint.replace('kg','')) * (100 - p ) / 100;
       document.getElementById('co2weight').innerHTML = `${co2}kg`;
     }

     return cfg;
   }).
   catch(console.error);

