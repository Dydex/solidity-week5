- Where are your structs, mappings and arrays stored.

In the EVM, where your structs, mappings, and arrays are stored depends on how and where they are declared. When these data types are declared as state variables at the contract level, they are stored in storage, which is the permanent, persistent area of the blockchain. This means structs, mappings, and arrays defined outside functions live in storage and remain saved between transactions. Storage is expensive in gas because writing to it modifies the blockchain state.

Inside functions, however, data can temporarily exist in memory or the stack. Structs and arrays can be created in memory using the memory keyword, and they will only exist during that function execution. They are not saved permanently. Mappings, on the other hand, cannot exist in memory at all, they can only live in storage because of how the EVM calculates their location using hashing. The stack is used for small, temporary primitive variables like uint, bool, and address during function execution. It is very fast but limited in size (1024 slots), which is why complex types like structs, mappings, and arrays do not live directly on the stack   



- How they behave when executed or called.

When structs, mappings, and arrays are executed or accessed in a function, their behavior depends on their data location (storage, memory, or stack) and whether you are working with a reference or a copy.

When a state variable (like a struct, mapping, or array) lives in storage, accessing it inside a function does not automatically copy it. If you use the storage keyword, you get a reference to the original data. Any modification you make updates the actual blockchain state. This costs gas because it changes storage.

If instead you use the memory keyword on a struct or array pulled from storage, Solidity creates a copy. Any changes you make affect only the temporary memory version and do not update the blockchain unless you explicitly write it back to storage. Memory data disappears after the function finishes executing.

Mappings behave differently. They always live in storage and cannot exist independently in memory. When you access a mapping like balances[msg.sender], the EVM calculates the storage slot using a keccak256 hash and directly reads or writes that location. There is no full “copy” of a mapping; you always interact with storage.

Arrays can behave like structs: if accessed with storage, you modify the original array; if copied into memory, you modify only a temporary version. Dynamic storage arrays also store their length in one slot and their elements in hashed storage slots, so pushing or modifying elements updates storage directly.

- Why don't you need to specify memory or storage with mappings

Ypu don't specify memory or storage with mappings because mappings can ony exist in storage in Solidity