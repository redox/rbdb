# OverrideRakeTask
Rake::TaskManager.class_eval do
  def remove_task(task_name)
    @tasks.delete(task_name.to_s)
  end
end
 
def remove_task(task_name)
  Rake.application.remove_task(task_name)
end

def override_task(args, &block)
  name, deps = Rake.application.resolve_args([args])  
  remove_task Rake.application[name].name
  task(args, &block)
end
