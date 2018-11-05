/*
    This script was developed by Piter Van Rujpen/TheGamerRespow for Vulkanoa (https://discord.gg/bzMnYPS).
    Do not re-upload this script without my authorization. (I only give authorization by PM on FiveM.net (https://forum.fivem.net/u/TheGamerRespow))
*/

var VK = new Object(); // DO NOT CHANGE
VK.server = new Object(); // DO NOT CHANGE

VK.backgrounds = new Object(); // DO NOT CHANGE
VK.backgrounds.actual = 0; // DO NOT CHANGE
VK.backgrounds.way = true; // DO NOT CHANGE
VK.config = new Object(); // DO NOT CHANGE
VK.tips = new Object(); // DO NOT CHANGE
VK.music = new Object(); // DO NOT CHANGE
VK.info = new Object(); // DO NOT CHANGE
VK.social = new Object(); // DO NOT CHANGE
VK.players = new Object(); // DO NOT CHANGE 

//////////////////////////////// CONFIG

VK.config.loadingSessionText = "Laddar session, vänligen vänta..."; // Loading session text
VK.config.firstColor = [160, 192, 228]; // First color in rgb : [r, g, b]
VK.config.secondColor = [119, 0, 255]; // Second color in rgb : [r, g, b]
VK.config.thirdColor = [0, 163, 218]; // Third color in rgb : [r, g, b]

VK.backgrounds.list = [ // Backgrounds list, can be on local or distant(http://....)
    "img/1.jpg",
    "img/2.jpg",
    "img/3.jpg",
];
VK.backgrounds.duration = 4000; // Background duration (in ms) before transition (the transition lasts 1/3 of this time)

VK.tips.enable = false; //Enable tips (true : enable, false : prevent)
VK.tips.list = [ // Tips list
    "Tryck \"F1\" för att använda din telefon. Telefon och GPS köper du i utvalda butiker.", // If you use double-quotes, make sure to put a \ before each double quotes
    "Tryck \"F2\" för att komma åt ditt personliga inventory.",
    "Tryck \"U\" för att låsa eller låsa upp ditt fordon.",
    "Håll in \"X\" för att hålla upp händerna.",
];

VK.music.url = "NONE"; // Music url, can be on local or distant(http://....) ("NONE" to desactive music)
VK.music.volume = 0.0; // Music volume (0-1)
VK.music.title = "NONE"; // Music title ("NONE" to desactive)
VK.music.submitedBy = "NONE"; // Music submited by... ("NONE" to desactive)

VK.info.logo = "icon/vulkanoa.png"; // Logo, can be on local or distant(http://....) ("NONE" to desactive)
VK.info.text = "NONE"; // Bottom right corner text ("NONE" to desactive) 
VK.info.website = "NONE"; // Website url ("NONE" to desactive) 
VK.info.ip = "NONE"; // Your server ip and port ("ip:port")

VK.social.discord = "NONE"; // Discord url ("NONE" to desactive)
VK.social.twitter = "NONE"; // Twitter url ("NONE" to desactive)
VK.social.facebook = "NONE"; // Facebook url ("NONE" to desactive)
VK.social.youtube = "NONE"; // Youtube url ("NONE" to desactive)
VK.social.twitch = "NONE"; // Twitch url ("NONE" to desactive)

VK.players.enable = false; // Enable the players count of the server (true : enable, false : prevent)
VK.players.multiplePlayersOnline = "@players spelare online"; // @players equals the players count
VK.players.onePlayerOnline = "1 spelare online"; // Text when only one player is on the server
VK.players.noPlayerOnline = "Inga spelare online"; // Text when the server is empty

////////////////////////////////
