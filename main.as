bool browserShown = false;

void Main(){
   print("Hello world!");
}

void RenderMenu(){
    if(UI::MenuItem("e621")){
        browserShown = !browserShown
    }
}