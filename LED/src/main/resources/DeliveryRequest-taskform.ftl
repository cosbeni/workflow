<input type="hidden" name="taskId" value="${task.id}"/>
<input type="hidden" id="pid" name="in_pid" value="${in_pid}"/>
<#if task.taskData.status = 'Ready'>	
   <h4>タスクを始めるには、引受する必要があります</h4> 
</#if>
<#if task.taskData.status = 'Reserved'>	
   <h4>入力する場合はタスクをスタートして下さい。</h4> 
</#if> 
<#if task.taskData.status = 'InProgress'>    
            <div class="row-fluid">
                <div class="span12">
                    <div class="tabbable">
                        <ul class="nav nav-tabs">
                            <li class="active"><a href="#customer" data-toggle="tab">顧客情報</a></li>
                            <li><a href="#process" data-toggle="tab" class="tab-item tab-item-designer">リードデータ入力</a></li>
                        </ul>
                        <div class="tab-content">
                            <div id="customer" class="tab-pane active">
                            </div>
                            <div id="process" class="tab-pane">
                                <div id="rental"></div>
                                <input type="button" class="save btn-large btn-primary" value="完了"/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
<script>
    formView.init = function () {
        var Alpaca = jQuery.alpaca;
        var pid = jQuery('#pid').val();
        jQuery.ajax({
            url: Alpaca.user.server + "/server/data/plenty/ＬＥＤレンタル?id=" + pid,
            type: "GET",
            dataType: "json",
            contentType: "application/json; charset=UTF-8"
        }).done(function (data) {
                    pageId = "ＬＥＤ現地調査結果";
                    $.ajax({
                        url: Alpaca.user.server + "/server/design/page/plenty?id=" + pageId,
                        type: "GET",
                        dataType: "json",
                        contentType: "application/json; charset=UTF-8"
                    }).done(function (responseText) {
                                jQuery("#rental").alpaca({
                                    "schemaSource": Alpaca.user.server + "/server/design/schema/plenty?id=" + responseText.schema,
                                    "optionsSource": Alpaca.user.server + "/server/design/options/plenty?id=" + responseText.options + "&sid=" + responseText.schema,
                                    "viewSource": Alpaca.user.server + "/server/design/view/plenty/?id=" + responseText.view + "&sid=" + responseText.schema,
                                    "data": data
                                });
                            });

                    var pageId = "顧客表示";
                    $.ajax({
                        url: Alpaca.user.server + "/server/design/page/plenty?id=" + pageId,
                        type: "GET",
                        dataType: "json",
                        contentType: "application/json; charset=UTF-8"
                    }).done(function (responseText) {
                                jQuery("#customer").alpaca({
                                    "schemaSource": Alpaca.user.server + "/server/design/schema/plenty?id=" + responseText.schema,
                                    "optionsSource": Alpaca.user.server + "/server/design/options/plenty?id=" + responseText.options + "&sid=" + responseText.schema,
                                    "viewSource": Alpaca.user.server + "/server/design/view/plenty/?id=" + responseText.view + "&sid=" + responseText.schema,
                                    "dataSource": Alpaca.user.server + "/server/data/plenty/顧客?id=" + data.顧客ＩＤ
                                });
                            });
                });

        jQuery("#process .save").click(function () {
            Alpaca.fieldInstances["ＬＥＤレンタル"].validate(true);
            Alpaca.fieldInstances["ＬＥＤレンタル"].renderValidationState(true);
            if (Alpaca.fieldInstances["ＬＥＤレンタル"].isValid(true)) {
                var json = Alpaca.fieldInstances["ＬＥＤレンタル"].getValue();
                json._id = { "$oid" : pid};
                jQuery.ajax({
                    url: Alpaca.user.server + "/server/data/plenty/ＬＥＤレンタル",
                    type: "POST",
                    dataType: "json",
                    contentType: "application/json; charset=UTF-8",
                    data: JSON.stringify(json)
                }).done(function (responseText) {
                            alert("OID:" + responseText._id.$oid + "を更新しました。");
                        });
            }
        });
    };

</script>            
</#if> 