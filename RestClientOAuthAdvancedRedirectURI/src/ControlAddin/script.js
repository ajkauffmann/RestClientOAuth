const guid = createGuid();
const state = targetUrl() + "|" + guid;
var timer;

function startAuthorization(params) {
    var objParams = JSON.parse(params);

    acquireAuthCodeSilent(objParams).then(response => {
        notifySuccess(response.code);
    }).catch(response => {
        if (response.error == "login_required" || response.error == "interaction_required" || response.error == "access_denied" || response.error == "timeout" || response.error == "consent_required") {
            acquireAuthCodePopup(objParams).then(response => {
                if (response.consent)
                    notifyAdminConsentSucceeded(response.tenant, response.scope);
                else
                    notifySuccess(response.code);
            }).catch(function (response) {
                notifyError(response.error, response.description)
            });
        } else {
            notifyError(response.error, response.description);
        }
    });

    function notifySuccess(code) {
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('AuthorizationCodeRetrieved', [code]);
    }

    function notifyAdminConsentSucceeded(tenant, scope) {
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('AdminConsentSucceeded', [tenant, scope]);
    }

    function notifyError(error, desc) {
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('AuthorizationErrorOccurred', [error, desc]);
    }
}

function acquireAuthCodeSilent(params) {
    return new Promise((resolve, reject) => {
        try {
            if (params.adminconsent) {
                reject(new responseException("consent_required", ''));
                return;
            }
            if (params.prompt && params.prompt != "none") {
                reject(new responseException("interaction_required", ''));
                return;
            }
            var url = getUrl(params, true);

            function handler(event) {
                if (params.redirect_uri.startsWith(event.origin) && (event.data.code = "OAuthResponseReceived")) {
                    window.removeEventListener("message", handler);
                    clearTimeout(timer);
                    document.body.removeChild(i);
                    handleResponse(event.data, resolve, reject);
                }
            }

            window.addEventListener("message", handler);

            var i = document.createElement("iframe");
            i.style.display = "none";
            document.body.appendChild(i);

            i.src = url;

            let timer = setTimeout(() => {
                window.removeEventListener("message", handler);
                document.body.removeChild(i);
                reject(new responseException('timeout', 'No response received'));
            }, 10000);
        } catch (e) {
            reject(new responseException(e.name, e.message));
        }
    })
}

function acquireAuthCodePopup(params) {
    return new Promise((resolve, reject) => {
        try {
            var url = getUrl(params, false);

            function handler(event) {
                if (params.redirect_uri.startsWith(event.origin) && (event.data.code == "OAuthResponseReceived")) {
                    window.removeEventListener("message", handler);
                    event.source.close();
                    handleResponse(event.data, resolve, reject);
                }
            }

            window.addEventListener("message", handler);
            window.open(url, '_blank', 'width=972,height=904,location=no');

        } catch (e) {
            reject(new responseException(e.name, e.message));
        }
    })
}

function handleResponse(data, resolve, reject) {
    try {
        var parameters = new URLSearchParams(data.response);
        if (!(checkState(parameters))) {
            reject(new responseException("invalid_state", "The state parameter is invalid"));
            return;
        }
        if (parameters.has("code")) {
            var response = { code: parameters.get("code") };
            resolve(response);
        } else if (parameters.has("admin_consent") && (parameters.get("admin_consent") == "True") && (!parameters.has("error"))) {
            var response = {
                consent: true,
                tenant: parameters.get("tenant"),
                scope: parameters.get("scope")
            };
            resolve(response);
        } else if (parameters.has("error")) {
            reject(new responseException(parameters.get("error"), parameters.get("error_description")));
        }
    } catch (e) {
        reject(new responseException(e.name, e.message));
    }
}

class responseException {
    constructor(error, description) {
        this.error = error;
        this.description = description;
    }
}

function checkState(params) {
    return (params.has("state") && params.get("state").split("|")[1] == guid);
}

function getUrl(params, silent) {
    var query = {
        state: state,
        redirect_uri: encodeURI(params.redirect_uri),
    };

    if (silent) {
        query.prompt = "none";
    } else if (params.prompt) {
        query.prompt = params.prompt;
    }

    if (params.code_challenge_method) {
        query.code_challenge_method = params.code_challenge_method;
        query.code_challenge = params.code_challenge;
    }

    var queryString = Object.keys(query).map(key => key + '=' + query[key]).join('&');

    return (params.authorization_endpoint.concat('&', queryString));
}

function createGuid() {
    function S4() {
        return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
    }

    return ((S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4()).toLowerCase());
}

function targetUrl() {
    return (location.protocol + '//' + location.hostname + (location.port ? ':' + location.port : ''));
}