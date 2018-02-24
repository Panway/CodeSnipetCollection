// chrome.browserAction.setBadgeText({text: 'Pan'});
// chrome.browserAction.setBadgeBackgroundColor({color: [255, 0, 0, 255]});

function test()
{
	alert('我是background！');
}

// 预留一个方法给popup调用
function testBackground() {
	// alert('你好，我是background！');
	return '66666';
}