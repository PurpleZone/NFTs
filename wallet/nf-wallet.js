// script to update dynamic logo parts
 const repo = 'wallet';
 const symbol = 'nf-wallet';
 const gw = 'https://ipfs.safewatch.care';
 const mutable = 'QmPhMEKGiuyXg9eq2x8aEgjnEMzR5tHEcuSBSMayzR9uVr';
 let path = 'https://cdn.jsdelivr.net/gh/PurpleZone/NFTs@latest/'+repo;
     path = gw + '/ipns/'+mutable;
 let jsonf = location.pathname.replace(/\.svg/,'.json');
 fetch(jsonf).then(resp => resp.json()).
  then(cfg => {
    console.log('cfg:',cfg);
    let kvs = {};
    for (let a of cfg.attributes) {
      kvs[a.trait_type] = a.value;
    }
    console.log('kvs.hash:',kvs.hash);

    if (typeof(kvs.hash) != 'undefined') {
      document.getElementById('qmhash').innerHTML = `${kvs.hash}`;
    }
    if (typeof(kvs.name) != 'undefined') {
      document.getElementById('fullname').innerHTML = `${kvs.name}`;
    }
    if (typeof(kvs.color) != 'undefined') {
      document.getElementById('shade').style.fill = document.getElementById('body').style.fill;
      document.getElementById('body').style.fill = `${kvs.color}`;
      //document.getElementById('style1076'). = `${kvs.color}`;
    }
    
  }).
  catch(console.error);
 
