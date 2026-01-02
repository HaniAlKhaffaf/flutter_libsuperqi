// JavaScript functions that can be called from Dart

// A simple function that returns a greeting
window.jsGreet = function (name) {
    return `Hello from JavaScript, ${name}!`;
};

// A function that shows an alert
window.jsShowAlert = function (message) {
    alert(message);
};

// A function that returns data
window.jsGetData = function () {
    return {
        message: "Data from JavaScript",
        timestamp: new Date().toISOString(),
        number: 42
    };
};

// A function that accepts a callback
window.jsCallWithCallback = function (callback) {
    setTimeout(() => {
        callback("Callback executed from JavaScript!");
    }, 1000);
};

// Expose a global object for Dart to access
window.jsBridge = {
    version: "1.0.0",
    getInfo: function () {
        return {
            platform: navigator.platform,
            userAgent: navigator.userAgent
        };
    }
};

