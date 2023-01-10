void getFromE(ref@ _tags){
    jsonResult = Json::Parse("{loading : 'true'}");
    auto tagsc = cast<Tags>(_tags);
    auto req = Net::HttpRequest();
    req.Method = Net::HttpMethod::Get;
    string rTags = "";
    for (uint i=0; i<tagsc.tags.Length; i++){
        rTags += tagsc.tags[i];
        if (i!=tagsc.tags.Length) rTags+="+";
    }
    req.Url = "https://e621.net/posts.json?limit=" + Setting_searchLimit +"&tags=" + rTags;
    req.Start();
    while (!req.Finished()) {
        yield();
    }
    jsonResult = Json::Parse(req.String());
    jsonResult['loading'] = 'false';
}