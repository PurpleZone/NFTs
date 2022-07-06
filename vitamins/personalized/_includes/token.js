// script to update dynamic logo parts
 const symb = 'phxvit';
 const reponame = 'vitamins';
 const gw = 'https://ipfs.safewatch.xyz';
 const immutable = 'QmXg18831o6mizuSeBpDEU7WZcpegVLdNd3goQYm6tB17S';
 const mutable = 'QmaEHEM1jz1rgR6Z9A2JzcpyekQvW96fUweQ15g6nP924w';
 let path = 'https://raw.githubusercontent.com/PurpleZone/NFTs/'+reponame
     path = 'https://cdn.jsdelivr.net/gh/PurpleZone/NFTs@latest/'+reponame
     //path = location.pathname.replace(/\/[^/]*$/,'');
     //path = gw+'/ipfs/'+immutable;
     path = gw+'/ipns/'+mutable;
 let jsonf = location.pathname.replace(/\.svg/,'.json');
 console.log('jsonf:',jsonf);
 console.log('path:',path);
 fetch(jsonf).then(resp => resp.json()).
  then(cfg => {
    console.log('cfg:',cfg);
    document.getElementById('qmhash').addEventListener('click',
      function() { location.href = gw+'/ipns/'+mutable; });
/*
    let qrcode_url = cfg.attributes[22].value
    document.getElementById('qrcode').setAttribute('xlink:href',`https://api.safewatch.xyz/api/v0/qrcode?url=$qrcode_url`)

    document.getElementById('pdf').addEventListener('click', function() { location.href = pdf_url; });
    document.getElementById('SPLtokenID').addEventListener('click',
      function() { location.href = 'https://explorer.solana.com/address/'+cfg.SPLtokenID; });
*/

    return cfg
  }).
  catch(console.error)


