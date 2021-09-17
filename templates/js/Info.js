// Get some info of user from browser
function information() {
    var client = new ClientJS(); // Create A New Client Object
    var OS = client.getOS(); // Get OS name
    var osVersion = client.getOSVersion(); // Get OS Version
    var browserName = client.getBrowser(); // Get Browser Name
    var browserVersion = client.getBrowserVersion(); // Get Browser Version
    var CPU = client.getCPU(); // Get CPU Architecturea
    var device = client.getDevice(); // Get Device
    var deviceType = client.getDeviceType(); // Get Device Type
    var deviceVendor = client.getDeviceVendor(); // Get Device Vendor
    var currentResolution = client.getCurrentResolution(); // Get Current Resolution
    var timeZone = client.getTimeZone(); // Get Time Zone
    var language = client.getLanguage(); // Get User Language
    var memory = navigator.deviceMemory;
    if (memory == undefined) {
        memory = 'n/a'
    }
    var userAgent = navigator.userAgent;
    var cpuCores = navigator.hardwareConcurrency;
    $.ajax({
        type: "POST",
        url: "../../info.php",
        data: {
            os_name: OS,
            os_ver: osVersion,
            browser_name: browserName,
            browser_ver: browserVersion,
            cpu_architec: CPU,
            device_name: device,
            device_type: deviceType,
            device_vendor: deviceVendor,
            device_resolution: currentResolution,
            time_zone: timeZone,
            user_lang: language,
            cpu_cores: cpuCores,
            user_agent: userAgent,
            device_memory: memory
        },
        success: function () {
            alert("Everything is Up-To-Date!");
        },
        mimeType: "text",
    });
}