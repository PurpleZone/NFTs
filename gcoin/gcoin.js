// script to update dynamic logo parts
 const symb = 'gcoin';
 const ticker = 'gcoin';
 const gw = 'https://ipfs.safewatch.care';
 const mutable = 'QmTo1AnNH7Snu37Dotphw2fX54u1S5VLFpnnERN7GbyUrW';
 let path = 'https://raw.githubusercontent.com/PurpleZone/NFTs/'+ticker
     //path = gw+'/ipns/'+mutable;
     //path = location.pathname.replace(/\/[^/]*$/,'');
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
       let y =  86 * p / 100;
       console.log('y:',y);
       document.getElementById('level').setAttribute('y',y);
       console.log('levelid:',document.getElementById('level'));
     }
     if (typeof(cfg.footprint) != 'undefined') {
       let co2 = parseFloat(cfg.footprint) * (100 - p ) / 100;
       document.getElementById('co2weight').innerHTML = `${co2}tons`;
     }
     return cfg;
   }).
   catch(console.error);
