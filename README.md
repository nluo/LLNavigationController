LLNavigationController
======================

A custom navigation controller


##Why do we want custom navigation controller?
### 1. Custom navigation bar

* By Default, the UINavigationController has the navigation bar fixed on top of the view with 44 pixels height. Sometimes we want to have a higher navigtation bar (or shorter) to fit the content or just simply for the aesthetic of the app.


* We might have a need to change the navigation bar position too.  

  ![alt tag](https://raw.githubusercontent.com/nick32m/LLNavigationController/assets/assets/screenshot1.png)

(Screenshot: the navigation bar is underneath a UIProgressView)
### 2. Custom Animation (work in progress)

We can choose the transistions ( [UIViewAnimationOptions](https://developer.apple.com/library/ios/documentation/uikit/reference/UIView_Class/UIView/UIView.html#//apple_ref/c/tdef/UIViewAnimationOptions) ) provided by the iOS SDK, that means we could do some fancy transistions such as flip when push/pop view controller:
 

   * UIViewAnimationOptionTransitionNone            
   * UIViewAnimationOptionTransitionFlipFromLeft   
   * UIViewAnimationOptionTransitionFlipFromRight   
   * UIViewAnimationOptionTransitionCurlUp          
   * UIViewAnimationOptionTransitionCurlDown        
   * UIViewAnimationOptionTransitionCrossDissolve   
   * UIViewAnimationOptionTransitionFlipFromTop     
   * UIViewAnimationOptionTransitionFlipFromBottom  