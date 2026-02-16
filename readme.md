# 📝 TodoDapp (Solidity)

A decentralized per-user task manager built in Solidity.

## Features .

- Add tasks
- Toggle completion status
- Delete tasks
- Per-user task isolation
- Gas-optimized storage patterns
- Custom errors for efficiency

## Contract Design

Each user has:
- Independent task counter
- Mapping of taskId → Task
- Array of task IDs for enumeration

Deletion uses swap-and-pop for gas efficiency.

## Security Notes

- No external calls → no reentrancy risk
- All state is user-scoped (msg.sender)
- Custom errors reduce gas usage

## Potential Improvements

- Add pagination to `getTasks()` (current version can become expensive with many tasks)
- Add updateTask function
- Add task timestamp
- Add task priority
- Consider indexing mapping to avoid O(n) deletion

## Deployment

Compile with Solidity ^0.8.20.

Example using Foundry:

```bash
forge build
forge test
forge script script/Deploy.s.sol --broadcast