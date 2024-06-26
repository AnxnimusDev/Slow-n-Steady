<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Agile Board</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="styles/AgileBoardStyles.css"/>
        <link rel="stylesheet" href="styles/tasks/tasks_Css.css"/>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <!-- Bootstrap Bundle con Popper -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
        <script defer src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <script
        src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.min.js"></script>
        <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js" integrity="sha256-xLD7nhI62fcsEZK2/v8LsBcb4lG7dgULkuXoXB/j91c=" crossorigin="anonymous"></script>
        <script src="scripts/drag.js" defer></script>
        <script>
            $(function () {
                $("#includeHtml").load("views/components/Navbar_View.jsp");
            });
        </script>
    </head>

    <body class="body">
        <div id="includeHtml"></div>
        <!-- BOARD -->
        <div class="board">
            <!-- SPRINT SELECT -->
            <div class="project-sprint-select-create">
                <form id="selectors" action="getProjectSprints" method="get">
                    <div class="projectSelect">
                        <label for="project-select">Projects:</label>
                        <select  class="form-select" aria-label="Default Select Example">
                            <option disabled selected value="">Select a project</option>
                            <c:forEach items="${userProjects}" var="userProject">
                                <option value="${userProject.getId()}">${userProject.getName()}</option>
                            </c:forEach>
                        </select>
                        <input type="hidden" id="projectId" name="project-id">
                    </div>
                    <div class="sprintSelect">
                        <label for="project-select">Project Sprints:</label>
                        <select class="form-select" aria-label="Default select example">
                        </select>
                    </div>
                    <script>
                        $(document).ready(function () {
                            $(".projectSelect").change(function () {
                                // var projectId = $(this).val();
                                var projectId = $(this).find("option:selected").val();
                                $("#projectId").val(projectId);
                                var $sprintSelect = $(this).closest(".project-sprint-select-create").find(".sprintSelect select");
                                $sprintSelect.empty();
                                $.ajax({
                                    url: "projectSprints",
                                    type: "GET",
                                    data: {action: "getProjectSprints", projectId: projectId},
                                    dataType: "json",
                                    success: function (data) {
                                        //Now we list the existing sprints for the selected project
                                        $sprintSelect.append('<option selected disabled value="">Select a sprint</option>');
                                        $.each(data, function (index, sprint) {
                                            $sprintSelect.append('<option value="' + sprint.id + '">' + sprint.name + '</option>');
                                        });
                                    },
                                    error: function (xhr, status, error) {
                                        console.error("ERROR getting Project Sprints: " + error);
                                    }
                                });
                            });
                        });
                    </script>
                </form>
                <form action="ProjectSprintsAPI" method="post">
                    <button class="createSprintButton btn btn-primary btn-lg" type="button" data-bs-toggle="modal"
                            data-bs-target="#createSprintModal">Create Sprint +</button>
                    <!-- CREATE SPRINT MODAL -->
                    <div class="modal fade" id="createSprintModal" tabindex="-1"
                         aria-labelledby="createSprintModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content bg-image-modal">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="createSprintModalLabel">Creating a Sprint</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <form>
                                        <div class="mb-3">
                                            <label for="sprint-name" class="col-form-label">Name:</label>
                                            <input id="sprintName" name="sprint-name" type="text" class="form-control" >
                                        </div>
                                        <div class="mb-3">
                                            <label for="sprint-description" class="col-form-label">Description:</label>
                                            <textarea id="sprintDescription" name="sprint-description" class="form-control"></textarea>
                                        </div>
                                        <div class="mb-3">
                                            <label for="start-date-picker" class="col-form-label">Start Date:</label>
                                            <div class="input-group date" id="startDatePicker">
                                                <input name="start-date-picker" size="16" type="date" class="form-control" id="startDate"/>
                                                <i class="fa fa-calendar"></i>
                                                <script type="text/javascript">
                                                    $(document).ready(function () {
                                                        $("#startDatePicker").datetimepicker({
                                                            format: 'MM/dd/yyyy hh:ii',
                                                            autoclose: true
                                                        });
                                                    });
                                                </script>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <label for="end-date-picker" class="col-form-label">End Date:</label>
                                            <div class="input-group date" id="endDatePicker">
                                                <input name="end-date-picker" size="16" type="date" class="form-control" id="endDate"/>
                                                <i class="fa fa-calendar"></i>
                                                <script type="text/javascript">
                                                    $(document).ready(function () {
                                                        $("#endDatePicker").datetimepicker({
                                                            format: 'yyyy-mm-dd hh:ii',
                                                            autoclose: true
                                                        });
                                                    });
                                                </script>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">Cancel</button>
                                    <button id="confirmCreateSprintButton" type="button" class="btn btn-primary">Create Sprint</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <script>
                        $(document).ready(function () {
                            $("#confirmCreateSprintButton").click(function () {
                                //We verified that the user at least gave the Sprint he's trying to create a name
                                var sprintName = $("#sprintName").val();
                                var sprintDescription = $("#sprintDescription").val();
                                var startDate = $("#startDate").val();
                                var endDate = $("#endDate").val();

                                if (sprintName.trim() === '') {
                                    alert("Please, enter at least a name for the new Sprint");
                                    return;
                                }

                                var sprintData = {
                                    "sprint-name": sprintName,
                                    "sprint-description": sprintDescription,
                                    "start-date-picker": startDate,
                                    "end-date-picker": endDate,
                                    "project-id": $(".projectSelect select").val()
                                };
                                console.log(sprintData);
                                //We send form data to the API through AJAX
                                $.ajax({
                                    url: "projectSprints",
                                    type: "POST",
                                    data: JSON.stringify(sprintData),
                                    contentType: "application/json",
                                    success: function (response) {
                                        //Handle server answer
                                        $(".sprintSelect select").append('option value="' + response.id + '">' + response.name + '</option>');
                                        $("#sprintName").val('');
                                        $("#sprintDescription").val('');
                                        $("#startDate").val('');
                                        $("#endDate").val('');
                                        location.reload();
                                    },
                                    error: function (xhr, status, error) {
                                        console.error("ERROR while creating new sprint: ", error);
                                        console.log(data);
                                        console.log(error);
                                    }
                                });
                            });
                        });
                    </script>
                </form>
                <form action="ProjectSprintsAPI" method="delete">
                    <button class="deleteSprintButton btn btn-danger btn-lg" type="button" data-bs-toggle="modal"
                            data-bs-target="#deleteSprintModal">Delete Sprint</button>
                    <!-- Delete Sprint Modal -->
                    <div class="modal fade" id="deleteSprintModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content bg-image-modal">
                                <div class="modal-header">
                                    <h1 class="modal-title fs-5" id="staticBackdropLabel">Deleting Sprint</h1>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <form>
                                        <div class="mb-3">
                                            <label for="are-you-sure" class="col-form-label">Are you sure you want to delete this sprint?</label>
                                            <label class="col-form-label">WARNING! Deleting the sprint will also delete the tasks asigned to it. In order to keep them, remove them from the sprint first.</label>
                                        </div>
                                    </form>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                    <button id="confirmDeleteSprintButton" type="button" class="btn btn-danger">DELETE</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <script>
                        $(document).ready(function () {
                            $("#confirmDeleteSprintButton").click(function () {
                                var sprintId = $(".sprintSelect select").val();
                                if (!sprintId) {
                                    alert("Please select a sprint to delete.");
                                    return;
                                }
                                console.log(sprintId);
                                $.ajax({
                                    url: "projectSprints?id=" + sprintId,
                                    type: "DELETE",
                                    success: function (response) {
                                        //If sprint deletion is successfull, we reload the page
                                        location.reload();
                                    },
                                    error: function (xhr, status, error) {
                                        console.error("ERROR deleting sprint: ", error);
                                    }
                                });
                            });
                        });
                    </script>
                </form>
                <form action="getSprintInfo" method="get">
                    <button class="sprintInfoButton btn btn-info btn-lg bg-gradient" type="button" data-bs-toggle="modal"
                            data-bs-target="#sprintInfoModal">Sprint Info</button>
                    <!-- SPRINT INFO MODAL -->
                    <div class="modal fade" id="sprintInfoModal" tabindex="-1"
                         aria-labelledby="sprintInfoModalLabel" aria-hidden="true">
                        <div id="sprintInfo" class="modal-dialog">
                            <div class="modal-content bg-image-modal">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="sprintInfoModalLabel">Sprint Information</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <form>
                                        <div class="mb-3">
                                            <label for="sprint-name" class="col-form-label">Name:</label>
                                            <input id="sprintNameInfo" name="sprint-name" type="text" class="form-control" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label for="sprint-description" class="col-form-label">Description:</label>
                                            <textarea id="sprintDescriptionInfo" name="sprint-description" class="form-control" readonly></textarea>
                                        </div>
                                        <div class="mb-3">
                                            <label for="start-date-picker" class="col-form-label">Start Date:</label>
                                            <div class="input-group date" id="startDatePicker">
                                                <input id="startDateInfo" name="start-date-picker" type="text" class="form-control" readonly>
                                                <span class="input-group-append">
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <label for="end-date-picker" class="col-form-label">End Date:</label>
                                            <div class="input-group date" id="endDatePicker">
                                                <input id="endDateInfo" name="end-date-picker" type="text" class="form-control" readonly>
                                                <span class="input-group-append">
                                            </div>
                                        </div>
                                    </form>
                                </div>
                                <div class="modal-footer">
                                    <button id="closeSprintInfoButton" type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">Close</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
                <script type="text/javascript">
                    $(document).ready(function () {
                        $(".sprintInfoButton").click(function () {
                            const infoModal = bootstrap.Modal.getOrCreateInstance('#sprintInfoModal');
                            console.log(infoModal);
                            var sprintId = $(".sprintSelect select").val();
                            if (!sprintId) {
                                alert("Please, select a sprint first.");
                                return;
                            }
                            var requestData = {
                                action: "getSprintInfo",
                                sprintId: sprintId
                            };
                            $.ajax({
                                url: "projectSprints",
                                type: "GET",
                                data: requestData,
                                dataType: "json",
                                success: function (data) {
                                    var sprintName = data.name;
                                    var sprintDescription = data.description;
                                    var startDate = data.startDate;
                                    var endDate = data.endDate;
                                    $("#sprintNameInfo").val(sprintName);
                                    $("#sprintDescriptionInfo").val(sprintDescription);
                                    $("#startDateInfo").val(startDate);
                                    $("#endDateInfo").val(endDate);
                                },
                                error: function (xhr, status, error) {
                                    console.error("ERROR Getting Sprint Info: " + error);
                                }
                            });
                        });
                    });
                </script>
            </div>
            <div class="lanes">
                <div id="sprint-backlog-lane" class="swim-lane" data-state-id="1">
                    <h3 class="heading">Sprint Backlog</h3>
                    <!--ADDING TASK MODAL-->
                    <form>
                        <button id="addTaskButton" class="btn btn-secondary btn-lg" type="button" data-bs-toggle="modal"
                                data-bs-target="#addTaskModal"> Add +</button>
                        <!-- ADD TASK MODAL -->
                        <div class="modal fade" id="addTaskModal" tabindex="-1" aria-labelledby="addTaskModalLabel"
                             aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content bg-image-modal">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="addTaskModalLabel">Adding Tasks</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <!-- ADD TASK MODAL BODY GOES HERE -->
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                                data-bs-dismiss="modal">Cancel</button>
                                        <button id="confirmAddTasksButton" type="button" class="btn btn-primary">Add Tasks</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                    <!<!-- Add Task Button functionality Script -->
                    <script>
                        $(document).ready(function () {
                            $("#addTaskButton").click(function () {
                                var projectId = $(".projectSelect select").val();
                                if (!projectId) {
                                    alert("Please, select a Project first");
                                    return;
                                }
                                var $modalBody = $('#addTaskModal').find('.modal-body');
                                var requestData = {
                                    action: "getProjectUntrackedTasks",
                                    projectId: projectId
                                };
                                $.ajax({
                                    url: "sprintTasks",
                                    type: "GET",
                                    data: requestData,
                                    dataType: "json",
                                    success: function (data) {
                                        //First we clear the modal existing body
                                        $modalBody.empty();
                                        //Iteramos sobre las tareas recibidas para mostrar su contenido en el modal
                                        $.each(data, function (index, task) {
                                            console.log(task);
                                            var taskInput = '<div class="input-group mb-3">' +
                                                    '<div class="input-group-text">' +
                                                    '<input class="form-check-input mt-0" type="checkbox" value="' + task.id + '" aria-label="Checkbox for following text input">' +
                                                    '</div>' +
                                                    '<input type="text" class="form-control" aria-label="Text input with checkbox" value="' + task.name + '" readonly>' +
                                                    '</div>';
                                            $modalBody.append(taskInput);
                                        });
                                    },
                                    error: function (xhr, status, error) {
                                        console.error("Error retrieving tasks: " + error);
                                    }
                                });
                            });
                            $("#confirmAddTasksButton").click(function () {
                                var projectId = $(".projectSelect select").val();
                                if (!projectId) {
                                    alert("Please, select a Project first");
                                    return;
                                }
                                var selectedTasksIds = [];
                                $("input[type='checkbox']:checked").each(function () {
                                    selectedTasksIds.push($(this).val());
                                });

                                // Verificar si se han seleccionado tareas antes de enviar la solicitud
                                if (selectedTasksIds.length === 0) {
                                    alert("Please, select at least one task to add to the sprint");
                                    return;
                                }

                                var requestData = {
                                    action: "addTasksToSprint",
                                    sprintId: $(".sprintSelect select").val(),
                                    selectedTasksIds: selectedTasksIds
                                };

                                $.ajax({
                                    url: "sprintTasks",
                                    type: "POST",
                                    data: requestData,
                                    success: function (response) {
                                        alert(response);
                                        location.reload();
                                    },
                                    error: function (xhr, status, error) {
                                        console.error("Error adding tasks to sprint: " + error);
                                    }
                                });
                            });
                        });
                    </script>
                    <div class="tasks-container"></div>
                </div>
                <div id="in-progress-lane" class="swim-lane" data-state-id="2">
                    <h3 class="heading">In Progress</h3>
                    <div class="tasks-container"></div>
                </div>
                <div id="for-testing-lane" class="swim-lane" data-state-id="3">
                    <h3 class="heading">Ready for Testing</h3>
                    <div class="tasks-container"></div>
                </div>
                <div id="completed-lane" class="swim-lane" data-state-id="4">
                    <h3 class="heading">Completed</h3>
                    <div class="tasks-container"></div>
                </div>
            </div>
            <!--Lanes functionality Script-->
            <script>
                $(document).ready(function () {
                    function loadTasksInLane(sprintId, stateId, laneSelector) {
                        var requestData = {
                            action: "loadTasks",
                            sprintId: sprintId,
                            stateId: stateId
                        };
                        $.ajax({
                            url: "sprintTasks",
                            type: "GET",
                            data: requestData,
                            dataType: "json",
                            success: function (data) {
                                var tasksContainer = $(laneSelector + " .tasks-container");
                                tasksContainer.empty();//We clear the existing tasks
                                $.each(data, function (index, task) {
                                    // Agregar un identificador único a cada tarea
                                    var taskId = sprintId + "_" + task.id;
                                    tasksContainer.append('<p id="' + taskId + '" class="task" draggable="true" data-task-id="' + task.id + '">' + task.name + '</p>');
//                                    tasksContainer.append('<p id="' + taskId + '" class="task" draggable="true" data-task-id="' + task.id + '" data-bs-toggle="modal" data-bs-target="#taskDetailsModal">' + task.name + '</p>');
                                });

                                setupDragAndDrop();
                            },
                            error: function (xhr, status, error) {
                                console.error("Error loading tasks: " + error);
                            }
                        });
                    }

                    //var projectId = $(".projectSelect select").val();
                    var sprintId = $(".sprintSelect select").val();

                    //Load tasks in every single lane, depending on its state
                    loadTasksInLane(sprintId, 1, "#sprint-backlog-lane");
                    loadTasksInLane(sprintId, 2, "#in-progress-lane");
                    loadTasksInLane(sprintId, 3, "#for-testing-lane");
                    loadTasksInLane(sprintId, 4, "#completed-lane");

                    //In order to change the displayed tasks when changing selected project or sprint
                    $(".sprintSelect select").change(function () {
                        //var newProjectId = $(".projectSelect select").val();
                        var newSprintId = $(".sprintSelect select").val();

                        // Eliminar las tareas del sprint anterior del DOM
                        $(".task").each(function () {
                            if (!$(this).attr("id").startsWith(newSprintId + "_")) {
                                $(this).remove();
                            }
                        });

                        // Limpiar las columnas de tareas antes de cargar las tareas del nuevo sprint
                        $(".swim-lane .tasks-container").empty();

                        //Load tasks in each lane with the new selected sprint and project
                        loadTasksInLane(newSprintId, 1, "#sprint-backlog-lane");
                        loadTasksInLane(newSprintId, 2, "#in-progress-lane");
                        loadTasksInLane(newSprintId, 3, "#for-testing-lane");
                        loadTasksInLane(newSprintId, 4, "#completed-lane");
                    });
                    // Función setupDragAndDrop
                    function setupDragAndDrop() {
                        const draggables = document.querySelectorAll(".task");
                        const droppables = document.querySelectorAll(".swim-lane");

                        draggables.forEach((task) => {
                            task.addEventListener("dragstart", () => {
                                task.classList.add("is-dragging");
                            });
                            task.addEventListener("dragend", () => {
                                task.classList.remove("is-dragging");
                            });
                        });

                        droppables.forEach((zone) => {
                            zone.addEventListener("dragover", (e) => {
                                e.preventDefault();
                                const bottomTask = insertAboveTask(zone, e.clientY);
                                const curTask = document.querySelector(".is-dragging");

                                if (curTask && !zone.contains(curTask)) {
                                    // Solo si la tarea arrastrada no es hija de esta columna
                                    zone.appendChild(curTask);
                                }
                            });

                            zone.addEventListener("drop", (e) => {
                                e.preventDefault();
                                const currTask = document.querySelector(".is-dragging");
                                const taskId = currTask.dataset.taskId;
                                const stateId = zone.dataset.stateId;

                                var reqData = {
                                    action: "modifyTaskState",
                                    taskId: taskId,
                                    stateId: stateId
                                }
                                //We do the AJAX request
                                $.ajax({
                                    url: "sprintTasks",
                                    type: "POST",
                                    data: reqData,
                                    success: function (response) {
                                    },
                                    error: function (xhr, status, error) {
                                        console.error("ERROR while trying to change Task State: " + error);
                                    }
                                });
                            });
                        });
                    }
                });
            </script>
            <!-- Task Info Modal -->
            <div class="modal fade" id="taskDetailsModal" tabindex="-1" aria-labelledby="taskDetailsModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content bg-image-modal">
                        <div class="modal-header">
                            <h5 class="modal-title" id="taskDetailsModalLabel">Task Details</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <form>
                                <div class="mb-3">
                                    <label for="task-name" class="col-form-label">Task Name:</label>
                                    <input id="taskNameInfo" name="task-name" type="text" class="form-control" readonly>
                                </div>
                                <div class="mb-3">
                                    <label for="task-description" class="col-form-label">Task Description:</label>
<!--                                    <input id="taskDescriptionInfo" name="task-description" type="text" class="form-control" readonly>-->
                                    <textarea id="taskDescriptionInfo" name="task-description" class="form-control" readonly></textarea>
                                </div>
                                <div class="mb-3">
                                    <label for="task-priority" class="col-form-label">Task Priority:</label>
                                    <input id="taskPriorityInfo" name="task-priority" type="text" class="form-control" readonly>
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <button type="button" class="btn btn-danger" id="resetTaskStateButton">Remove Task from Sprint</button>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Task Info Modal Functionality Script -->
            <script type="text/javascript">
                const infoModal = bootstrap.Modal.getOrCreateInstance('#taskDetailsModal');
                // Agregar evento de doble clic a las tareas
                $(document).on('dblclick', '.task', function () {
                    // Obtener los detalles de la tarea
                    var taskId = $(this).data('task-id');
                    // Establecer el ID de la tarea en el botón que abre el modal
                    $("#resetTaskStateButton").data('task-id', taskId);
                    var requestData = {
                        action: "getTaskDetails",
                        taskId: taskId
                    };
                    $.ajax({
                        url: "sprintTasks",
                        type: "GET",
                        data: requestData,
                        dataType: "json",
                        success: function (data) {
                            // Mostrar los detalles de la tarea en el modal
                            $("#taskNameInfo").val(data.name);
                            $("#taskDescriptionInfo").val(data.description);
                            $("#taskPriorityInfo").val(data.priority);
                            // Abrir el modal
                            infoModal.show();
                        },
                        error: function (xhr, status, error) {
                            console.error("Error loading task details: " + error);
                        }
                    });
                });

                $("#resetTaskStateButton").click(function () {
                    var taskId = $(this).data('task-id');
                    console.log(taskId);
                    var requestData = {
                        action: "removeTaskFromSprint",
                        taskId: taskId
                    };
                    $.ajax({
                        url: "sprintTasks",
                        type: "POST",
                        data: requestData,
                        success: function (response) {
                            // Cerrar el modal después de restablecer el estado de la tarea
                            infoModal.hide();
                            // Actualizar la página para reflejar los cambios
                            location.reload();
                        },
                        error: function (xhr, status, error) {
                            console.error("Error resetting task state: " + error);
                        }
                    });
                });
            </script>
        </div>
    </body>

</html>