SingleTrack
===========

Overridden for testing asynchronous behavior with GCD queues

[x]dispatch_queue_t
[x]dispatch_queue_create
[x]dispatch_sync
[x]dispatch_async
[/]dispatch_once_t
[/]dispatch_once
[x]dispatch_group_t
[x]dispatch_group_create
[ ]dispatch_group_enter
[ ]dispatch_group_leave
[ ]dispatch_group_async
[ ]dispatch_group_notify
[ ]dispatch_group_wait
[ ]dispatch_suspend
[ ]dispatch_resume
[x]dispatch_get_main_queue
[x]dispatch_get_global_queue
[ ]dispatch_semaphore_t
[ ]dispatch_semaphore_create
[ ]dispatch_semaphore_signal
[ ]dispatch_semaphore_wait
[?]dispatch_set_context
[?]dispatch_get_context
[?]dispatch_set_finalizer_f
[?]dispatch_apply
[?]dispatch_apply_f

Additional methods:
[x]dispatch_queues
[x]dispatch_groups
[x]dispatch_queue_tasks

[x]dispatch_execute_next_task // SERIAL
[x]dispatch_execute_task_at_index // CONCURRENT
[x]dispatch_execute_all_tasks // SERIAL or CONCURRENT

