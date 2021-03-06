// script to update dynamic logo parts
 const symb = 'eo-coin';
 const ticker = 'eoc';
 const gw = 'https://ipfs.safewatch.care';
 const immutable = 'QmYsqLqjJrZzGUg1ZjGjP1fsDtzLuT3oD3nT6JqLGjwKkn';
 const mutable = 'QmVYhabrNidUzhLmDpbB28JxK12mUbagDuEj8VnwdMugqr';
 let path = 'https://raw.githubusercontent.com/PurpleZone/NFTs/'+ticker
     path = 'https://cdn.jsdelivr.net/gh/PurpleZone/NFTs@latest/'+ticker
     path = gw+'/ipns/'+mutable;
     //path = location.pathname.replace(/\/[^/]*$/,'');
 console.log('path:',path);
 fetch(path+`/${symb}.json`).then(resp => resp.json()).
   then(cfg => {
   console.log('cfg:',cfg);
   document.getElementById('leaf').addEventListener('click',
        function() { location.href = path+'/factsheet.html'; }
        );
     if (typeof(cfg.attributes[1].value) != 'undefined') {
       document.getElementById('co2weight').innerHTML = `${cfg.attributes[1].value}`;
     }
     document.getElementById('qmhash').innerHTML = immutable;

     return cfg;
   }).
   catch(console.error);

