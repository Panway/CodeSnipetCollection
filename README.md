# CodeSnipetCollection
code snipet collection for Objective-C, Shell, Python...

```js
// ==UserScript==
// @name         打开Mac斗鱼播放器
// @namespace    http://tampermonkey.net/
// @version      0.1.1
// @description  用Mac斗鱼打开直播间
// @author       Garyon
// @match        *://*.douyu.com/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    $(document).ready(function(){
        setTimeout(function(){
            var roomid=/\d+/.exec($(".feedback-report-button").attr("href"));
            //var rid = /\d+/.exec($(".play-list-link").attr("data-rid"));
            $('.play-list-link').each(function() {
                //var subnode = $(this).attr('href');
                var rid = $(this).data('rid');
                $(this).attr("href", 'dy://room/'+ rid)
            });
            $(".r-else").append('<li><span style="background:#ff0000;" id="openMacPlayer"><a href = "dy://room/'+ roomid +'">用Mac斗鱼打开</span></li>');
        },1000);
    });
})();
```
