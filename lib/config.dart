import 'package:share/share.dart';

const DEVELOPER_KEY='AIzaSyASPZv9fvjZXhHYTDqs7P5LwjH0XF4Cw6k';
const YOUTUBE_DATA_URL='https://www.googleapis.com/youtube/v3';
const YOUTUBE='https://www.youtube.com';
const INITIALCHANNEL='UCg9NadeQbjGL80cDnCf1g-A';
const PLAYSTORE_LINK='https://play.google.com/store/apps/details?id=com.rabsdeveloper.fun_tube';
const FAILURE='Connection Failed!';
dynamic MAX=5;

const dynamic CHANNELS=[
  'UC4B6dDVB0Umrh5l4UgxUtyg', //MY FAMILY
  'UC76Yc75RGWonijH02CIhPaw', //Great Indian Comedy
  'UCtZie1TODEYT98YZb0b85Ow', //Comedy No1
  'UCBXMpFsxz-QyFEevJgPl-Og', //Me TV
  'UC-3fLOkTRb7-tepOqxsDdDg', //Funny ki Vines
  'UCOYWgypDktXdb-HfZnSMK6A', //Tomska
  'UCALeHfwxZslowXw-ug7tT7g', //Comedy Captain
  'UCVJK2AT3ea5RTXNRjX_kz8A', //Tobuscus
  'UC0yoDn4jXS2S_rPn958otyQ', //xploit comedy
  'UCvO4Ym5LjYTo0uZRfUvtc-w', //AYTVAYTV
  'UCakrXQVjsmclKHmnCIqlFMg', //YawaSkits
  'UC21wkgymoyIu6AdqJ6Q7QcA', //ArewaZoneTv
  'UCJ20zypeIOVkYPtQNfzV1zw', //AkpanAndOdunma
  'UCUsN5ZwHx2kILm84-jPDeXw', //comedycentral
  'UCN9wHzrHRdKVzCSeV-5RuzA', //ShaneDawsonTV
  'UC9gFih9rw0zNCK3ZtoKQQyA', //Jenna Marbles
  'UCg9NadeQbjGL80cDnCf1g-A', //Oaga Eubu
  'UCY30JRSgfhYXA6i6xX1erWg', //Smosh
  'UCSAUGyc_xA8uYzaIVG6MESQ', //Nigahiga
  'UCod9JyI9JNWtoFeCy30d1vA', //Riceman
  'UCLGmRp8S44uM31RIz-CrfCA', //Comedy Cricle
  'UCEmCXnbNYz-MOtXi3lZ7W1Q', //Barely Political
  'UCOSMYm1yZ7LIHwERXphGAYw', // Dash XP
  'UCbochVIwBCzJb9I2lLGXGjQ', //RhettandLink
  'UCPcFg7aBbaVzXoIKSNqwaww', //Jack Film
  'UCJLT0eZh-17IXsiEYtG2KqA', //Kings Comedy
  'UCMu5gPmKp5av0QCAajKTMhw', //ERB
  'UCs8FY0Xz-ibgINp5o3iqo6Q', //
  'UCGt7X90Au6BV8rf49BiM6Dg', //RayWilliamJohnson
  'UCfm4y4rHF5HGrSr-qbvOwOg', //IISuperwomanII
  'UCJcPQcceYkC6QVmDM3hE-lw',  //Mwombe Online
  'UCQFjvnrDBxMZIRaZHzv1yqA', //Arewa Comedians
  'UCrndsMTe0v32eqR1rTA8rhQ', //Bosho Comedy
  'UCpI8pKk_eDaMblO5qPnUq3w', //HausaTop Tv
  'UCE8AqqfFvKvK660Rk19o61g', //Tauraruwar Arewa TV
  'UCvlVuntLjdURVD3b3Hx7kxw',  //Dry Bar Comedy  
  'UCod_t2sXD_gRI11yFFGkoXg', //Vines best fun
  'UCcMF-mXYzm7nXuIwpPtN1yQ', //Comedy Channel
  'UCdN4aXTrHAtfgbVG9HjBmxQ',  //Key & Peele
  'UCs8yiVNA6Qt1Crohqwpvryw',  //fk Comedy Tv
  'UCqq3PZwp8Ob8_jN0esCunIw', //Just For Laughs
  'UCtl7BVgRMGDUcLOD1MIqiYw', //wapTVchannel
  'UC52gIpD4YXyGviN-4vjuXeQ', //Bindas Fun 
  'UCCU6W0MeQgrT_RhBohkoOPg', //Kix Vines
  'UCEFiMrYQmfIfozesU2NCTdQ', //Simmi Singh
  'UCOeVhGZOgV_s0mOcVeGpatQ', //ABC Comedy
  'UC_NT0EK1f9CoWnzPJV1pj1A', //BBC Comedy
  'UCFXjGOrHol65hSuyiW2OkQQ', //videos funny
  'UCsIEFXNO4bxh0hW3-_z2-0g' //Comedy Club
];

String getFormated(String numbers){
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  numbers.replaceAll(',', ''); 
  return numbers.replaceAllMapped(reg, mathFunc);
}

