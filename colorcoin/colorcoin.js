console.log('running colorcoin js !');

fetch('colorcoin.json').then(resp =&gt; resp.json()).
   then(cfg =&gt; {
   console.log('cfg:',cfg);
   //document.getElementById('logo').addEventListener('click', function() { location.href = 'colorcoin.json' } )
     if (typeof(cfg.name) != 'undefined') {
       document.getElementById('cctext').innerHTML = `${cfg.value}${cfg.unit}`;
     }
     return cfg;
   }).
   catch(console.error);

