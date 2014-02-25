
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
                            <div id="process">
                                与信登録
                                <input type="button" class="release btn-large btn-primary" value="リリース"/>
                                <input type="button" class="complete btn-large btn-primary" value="完了"/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
<script>
    formView.init = function () {
        jQuery("#process .release").click(function () {
                releaseTask(getFormValues(document.getElementById("form-data")));
        });
        jQuery("#process .complete").click(function () {
                completeTask(getFormValues(document.getElementById("form-data")));
        });
    };
</script>            
</#if> 