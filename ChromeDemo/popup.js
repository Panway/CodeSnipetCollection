  var current_url = '666';

  function getCurrentTabUrl(callback) {
    // Query filter to be passed to chrome.tabs.query - see
    // https://developer.chrome.com/extensions/tabs#method-query
    var queryInfo = {
      active: true,
      currentWindow: true
    };

    chrome.tabs.query(queryInfo, (tabs) => {

      var tab = tabs[0];

      // A tab is a plain object that provides information about the tab.
      // See https://developer.chrome.com/extensions/tabs#type-Tab
      var url = tab.url;
      current_url = url;
      // tab.url is only available if the "activeTab" permission is declared.
      // If you want to see the URL of other tabs (e.g. after removing active:true
      // from |queryInfo|), then the "tabs" permission is required to see their
      // "url" properties.
      if (typeof url != 'string') {
        alert('当前url不是字符串')
        return;
      }
      //     var bg = chrome.extension.getBackgroundPage();
      // bg.test(); // 访问bg的函数
      // alert(bg.document.body.innerHTML); // 访问bg的DOM
      console.log('当前URL======' + url);
      // var pandatext = document.getElementById("pandatext");
      // 获取元素
      var pandatext = document.getElementById('pandatext');
      var generateQRcodeButton = document.getElementById('generate_qr_code');
      var currentURLQRCodeButton = document.getElementById('currentURLQRCode');
      // var changeBackgroundColorButton = document.getElementById('change_background_color');

      // 设置 input 元素的值
      pandatext.value = url;

      // 生成 QR Code
      generateQRcode(url,tab);

      // 断言 url 的类型为字符串
      console.assert(typeof url === 'string', 'tab.url should be a string');

      // 添加点击事件监听器
      generateQRcodeButton.addEventListener('click', makeCode);
      currentURLQRCodeButton.addEventListener('click', currentURLQRCode);
      // changeBackgroundColorButton.addEventListener('click', function() {
      //     changeBackgroundColor('#c7edcc');//护眼绿色
      // });

      callback(url);
    });

    // Most methods of the Chrome extension APIs are asynchronous. This means that
    // you CANNOT do something like this:
    //
    // var url;
    // chrome.tabs.query(queryInfo, (tabs) => {
    //   url = tabs[0].url;
    // });
    // alert(url); // Shows "undefined", because chrome.tabs.query is async.
  }

  /**
   * Change the background color of the current page.
   *
   * @param {string} color The new background color.
   */
  function changeBackgroundColor(color) {
    var script = 'document.body.style.backgroundColor="' + color + '";';
    // See https://developer.chrome.com/extensions/tabs#method-executeScript.
    // chrome.tabs.executeScript allows us to programmatically inject JavaScript
    // into a page. Since we omit the optional first argument "tabId", the script
    // is inserted into the active tab of the current window, which serves as the
    // default.
    chrome.tabs.executeScript({
      code: script
    });
  }

  /**
   * Gets the saved background color for url.
   *
   * @param {string} url URL whose background color is to be retrieved.
   * @param {function(string)} callback called with the saved background color for
   *     the given url on success, or a falsy value if no color is retrieved.
   */
  function getSavedBackgroundColor(url, callback) {
    // See https://developer.chrome.com/apps/storage#type-StorageArea. We check
    // for chrome.runtime.lastError to ensure correctness even when the API call
    // fails.
    chrome.storage.sync.get(url, (items) => {
      callback(chrome.runtime.lastError ? null : items[url]);
    });
  }

  /**
   * Sets the given background color for url.
   *
   * @param {string} url URL for which background color is to be saved.
   * @param {string} color The background color to be saved.
   */
  function saveBackgroundColor(url, color) {
    var items = {};
    items[url] = color;
    // See https://developer.chrome.com/apps/storage#type-StorageArea. We omit the
    // optional callback since we don't need to perform any action once the
    // background color is saved.
    chrome.storage.sync.set(items);
  }

  function makeCode() {
    
    // alert('Bingo!=================');
    var pandatext = document.getElementById("pandatext");
    generateQRcode(pandatext.value);
  }

  function currentURLQRCode() {
    generateQRcode(current_url);
  }

  
  function generateQRcode(text,tab) {
    if (!text) {
      alert("Please input text");
      pandatext.focus();
      return;
    }

    console.log("----------generateQRcode");
    
    // 清空子节点（上次生成的二维码）
    var qrCodeNode = document.getElementById("qrcode");
    while (qrCodeNode.firstChild) {
      qrCodeNode.removeChild(qrCodeNode.firstChild);
    }
    //执行二维码第三方库 
    chrome.tabs.query({ active: true, currentWindow: true }, function (tabs) {
      var currentUrl = tabs[0].url;
      var qrcode = new QRCode(document.getElementById("qrcode"), {
        width: 250,
        height: 250
      });
      qrcode.makeCode(text.length > 0 ? text : currentUrl);
    });
  }

  document.addEventListener('DOMContentLoaded', () => {
    getCurrentTabUrl((url) => {
      console.log('PPPan=====');
      // alert('Pan da shen');

      var dropdown = document.getElementById('dropdown');

      // Load the saved background color for this page and modify the dropdown
      // value, if needed.
      getSavedBackgroundColor(url, (savedColor) => {
        if (savedColor) {
          changeBackgroundColor(savedColor);
          dropdown.value = savedColor;
        }
      });

      // Ensure the background color is changed and saved when the dropdown
      // selection changes.
      dropdown.addEventListener('change', () => {
        changeBackgroundColor(dropdown.value);
        saveBackgroundColor(url, dropdown.value);
      });
    });
  });