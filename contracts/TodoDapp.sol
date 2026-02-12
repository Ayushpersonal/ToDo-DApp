// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TodoDapp {

    error InvalidTaskId();
    error EmptyContent();

    struct Task {
        uint256 id;
        string content;
        bool completed;
    }

    // user => taskId => Task
    mapping(address => mapping(uint256 => Task)) private tasks;

    // user => list of task IDs
    mapping(address => uint256[]) private userTaskIds;

    // user => next task ID counter
    mapping(address => uint256) private taskCounter;

    event TaskCreated(address indexed user, uint256 id, string content);
    event TaskToggled(address indexed user, uint256 id, bool completed);
    event TaskDeleted(address indexed user, uint256 id);

    function addTask(string calldata _content) external {
        if (bytes(_content).length == 0) revert EmptyContent();

        uint256 newId = taskCounter[msg.sender]++;
        
        tasks[msg.sender][newId] = Task({
            id: newId,
            content: _content,
            completed: false
        });

        userTaskIds[msg.sender].push(newId);

        emit TaskCreated(msg.sender, newId, _content);
    }

    function getTasks() external view returns (Task[] memory) {
        uint256[] storage ids = userTaskIds[msg.sender];
        uint256 length = ids.length;

        Task[] memory result = new Task[](length);

        for (uint256 i = 0; i < length; i++) {
            result[i] = tasks[msg.sender][ids[i]];
        }

        return result;
    }

    function toggleTask(uint256 _id) external {
        Task storage task = tasks[msg.sender][_id];

        if (bytes(task.content).length == 0) revert InvalidTaskId();

        task.completed = !task.completed;

        emit TaskToggled(msg.sender, _id, task.completed);
    }

    function deleteTask(uint256 _id) external {
        uint256[] storage ids = userTaskIds[msg.sender];
        uint256 length = ids.length;

        Task storage task = tasks[msg.sender][_id];
        if (bytes(task.content).length == 0) revert InvalidTaskId();

        // remove from ID array (swap & pop)
        for (uint256 i = 0; i < length; i++) {
            if (ids[i] == _id) {
                ids[i] = ids[length - 1];
                ids.pop();
                break;
            }
        }

        delete tasks[msg.sender][_id];

        emit TaskDeleted(msg.sender, _id);
    }
}