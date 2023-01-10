bool browserShown = false;
string inputTags = "";
Json::Value jsonResult = Json::Parse("{loading : true}");
void Main(){
    if(Setting_FirstTimeUse){
        Setting_FirstTimeUse=false;
        UI::ShowNotification(Icons::Paw + " e621 browser", "Please head to the settings to enable the plugin!", UI::HSV(0.33, 0.33, 0.33), 10000);
    }
    if (!Setting_isOverEighteen) return;
    print("Hello world!");
}

void RenderMenu(){
    if (!Setting_isOverEighteen) return;
    if(UI::MenuItem(Icons::Paw+" e621 browser window", "", browserShown)){
        browserShown = !browserShown;
    }
}

void Render(){
    if (!Setting_isOverEighteen) return;
    if (!browserShown) return;

    UI::SetNextWindowSize(500, 500);
    UI::SetNextWindowPos(50, 50);
    if (UI::Begin(Icons::Paw + " e621 browser", browserShown, UI::WindowFlags::NoCollapse)){
        inputTags = UI::InputText("Enter some tags", inputTags, 0);
        bool clicked =  UI::Button("Search");
        if (clicked){
            array<string> searchTags = inputTags.Split(" ");
            auto tagsBox = Tags(searchTags);
            startnew(getFromE, tagsBox); 
        }
        if (jsonResult['loading']=='true'){
            UI::Text("Loading...");
        } else {
            UI::Text(jsonResult['posts'][0]['created_at']);
        }
        
    }
    UI::End();
}