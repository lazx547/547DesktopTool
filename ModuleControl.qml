import QtQuick

Item {

    function resetActive()
    {
        for(var i=0;i<$Modules.length;i++)
        {
            $Modules[i].active=false
            $ModuleErs[i].visible=false
        }
    }
    function createnew(n)
    {
        $objects.push($modules[n].createObject())
        $objects[$objects.length-1].thisn=$objects.length-1
        var a=$objects.length-1
        console.log(a)
        $ModuleErs[n].add(a)
    }
    function exit(n,a)
    {
        $ModuleErs[a].del(n)
    }
}
