bool browserShown = false;
string inputTags = "";
Json::Value jsonResult = Json::Parse('{"loading" : false}');
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

    UI::SetNextWindowSize(Window_Width,Window_Height);
    UI::SetNextWindowPos(50, 50);
    if (UI::Begin(Icons::Paw + " e621 browser", browserShown, UI::WindowFlags::NoCollapse | UI::WindowFlags::HorizontalScrollbar)){
        inputTags = UI::InputText("Enter some tags", inputTags, 0);
        bool clicked =  UI::Button("Search");
        if (clicked){
            array<string> searchTags = inputTags.Split(" ");
            auto tagsBox = Tags(searchTags);
            startnew(getFromE, tagsBox); 
        }
        bool loading = jsonResult['loading'];
        if (loading){
            UI::Text("Loading...");
        } else if (jsonResult.HasKey('posts')){
            string s = "";
            for (int i = 0; i<Query_searchLimit; i++){
                if (!jsonResult['posts'][i].HasKey('file') || !jsonResult['posts'][i].HasKey('preview')) break;
                string ext = jsonResult['posts'][i]['file']['ext'];
                if(ext != "png" && ext != "jpg") continue;
                string imgLink = jsonResult['posts'][i]['preview']['url'];
                s += "dummy\n";
            }
            UI::Text(s);
        } else {
            UI::Text("No search yet!");
        }
        
    }
    UI::End();
}