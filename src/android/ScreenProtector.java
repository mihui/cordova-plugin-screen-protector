/**
 * SecureScreen Plugin
 */
package mihui.net;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;

import android.app.Activity;
import android.view.WindowManager;
import android.webkit.ValueCallback;
import android.webkit.WebView;

/**
 * @author mihui
 *
 */
public class ScreenProtector extends CordovaPlugin {
	@Override
	public void initialize(CordovaInterface cordova, final CordovaWebView webView) {
		super.initialize(cordova, webView);
        initializeWithActivity(this.cordova.getActivity());
	}

	public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {
        return false;
	}

    public static void initializeWithActivity(Activity activity) {
        activity.getWindow().setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE);
    }

    public static void onPause(final CordovaWebView _webView){
        if(_webView != null){
            final String jsString = "cordova.fireWindowEvent('protector.pause');";
            new Thread(new Runnable(){
                @Override
                public void run() {
                    _webView.loadUrl("javascript:"+jsString);
                }
            });
        }
    }

    public static void onResume(final CordovaWebView _webView){
        if(_webView != null){
            final String jsString = "cordova.fireWindowEvent('protector.resume');";
            new Thread(new Runnable(){
                @Override
                public void run() {
                    _webView.loadUrl("javascript:"+jsString);
                }
            });
        }
    }
}
