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
                            <li class="active"><a href="#customer" data-toggle="tab">店舗情報</a></li>
                        </ul>
                        <div class="tab-content">
                            <div id="customer" class="tab-pane active">
                            </div>
                            <div id="process" class="tab-pane">
                                <div id="rental"></div>
                                <input type="button" class="release btn-large btn-primary" value="リリース"/>
                                <input type="button" class="save btn-large btn-primary" value="保存"/>
                                <input type="button" class="complete btn-large btn-primary" value="完了"/>
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
                    var pageId = "顧客編集";
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

        jQuery("#process .release").click(function () {
                releaseTask(getFormValues(document.getElementById("form-data")));
        });
        jQuery("#process .save").click(function () {
            Alpaca.fieldInstances["顧客"].validate(true);
            Alpaca.fieldInstances["顧客"].renderValidationState(true);
            if (Alpaca.fieldInstances["顧客"].isValid(true)) {
                var json = Alpaca.fieldInstances["顧客"].getValue();
                jQuery.ajax({
                    url: Alpaca.user.server + "/server/data/plenty/顧客",
                    type: "POST",
                    dataType: "json",
                    contentType: "application/json; charset=UTF-8",
                    data: JSON.stringify(json)
                }).done(function (responseText) {
                            alert("OID:" + responseText._id.$oid + "で更新できました。");
                        });
            }
        });
        jQuery("#process .complete").click(function () {
            Alpaca.fieldInstances["顧客"].validate(true);
            Alpaca.fieldInstances["顧客"].renderValidationState(true);
            if (Alpaca.fieldInstances["顧客"].isValid(true)) {
                var json = Alpaca.fieldInstances["顧客"].getValue();
                jQuery.ajax({
                    url: Alpaca.user.server + "/server/data/plenty/顧客",
                    type: "POST",
                    dataType: "json",
                    contentType: "application/json; charset=UTF-8",
                    data: JSON.stringify(json)
                }).done(function (responseText) {
                            completeTask(getFormValues(document.getElementById("form-data")));
                        });
            }
        });
    };

</script>            
</#if> 