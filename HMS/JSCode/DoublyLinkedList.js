class Item {
    constructor(val) {
        this.val = val;
        this.next = null;
        this.prev = null;
    }
}

class DoublyLinkedList {
    constructor() {
        this.head = null;
        this.tail = null;
        this.data_items = {}
        this.length = 0;
    }

    push(key, val) {
        const newItem = new Item(key, val);
        this.data_items[key] = newItem;
        if (this.length === 0) {
            this.head = newItem;
            this.tail = newItem;
        } else {
            this.tail.next = newItem;
            newItem.prev = this.tail;
            this.tail = newItem;
        }
        this.length++;
        return this;
    }

    get(key) {
        return this.data_items[key];
    }

    pop() {
        if (this.length === 0) return undefined;
        const temp = this.tail;
        if (this.length === 1) {
            this.head = null;
            this.tail = null;
        } else {
            this.tail = temp.prev;
            this.tail.next = null;
            temp.prev = null;
        }
        this.length--;
        return temp;
    }

    shift() {
        if (this.length === 0) return undefined;
        const temp = this.head;
        if (this.length === 1) {
            this.head = null;
            this.tail = null;
        } else {
            this.head = temp.next;
            this.head.prev = null;
            temp.next = null;
        }
        this.length--;
        return temp;
    }

    unshift(val) {
        const newItem = new Item(val);
        if (this.length === 0) {
            this.head = newItem;
            this.tail = newItem;
        } else {
            newItem.next = this.head;
            this.head.prev = newItem;
            this.head = newItem;
        }
        this.length++;
        return this;
    }
}