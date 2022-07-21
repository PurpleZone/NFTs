// script to update dynamic logo parts
 const reponame = 'token';
 const gw = 'https://ipfs.safewatch.xyz';
 let path = 'https://raw.githubusercontent.com/PurpleZone/NFTs/'+reponame
     path = 'https://cdn.jsdelivr.net/gh/PurpleZone/NFTs@latest/'+reponame
     //path = location.pathname.replace(/\/[^/]*$/,'');
     //path = gw+'/ipfs/'+immutable;
     path = gw+'/ipns/'+mutable;
 let jsonf = location.pathname.replace(/\.svg/,'.json');
 console.log('jsonf:',jsonf);
 console.log('path:',path);


