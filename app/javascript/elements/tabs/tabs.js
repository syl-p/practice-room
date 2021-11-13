import styles from './tabs.style'
export class Tabs extends HTMLElement {
    constructor() {
        super();
        this.currentTab = 0;
        this.shadow = this.attachShadow({mode: 'open'})
    }

    connectedCallback() {
        this.shadow.innerHTML = `
            <style>${styles}</style>
            <slot name="nav" class="panel-nav">
            </slot>
            <slot name="content" class="panel-body">
                <slot name="tab"></slot>
            </slot>
        `
        // Get structure
        this.navSlot = this.shadow.querySelector('slot[name=nav]')
        this.contentSlot = this.shadow.querySelector('slot[name=content]')
        this.tabSlot = this.shadow.querySelector('slot[name=tab]')

        this.tabList = document.createElement('ul')
        this.tabList.classList.add('tab', 'tab-block')

        // get tabs from tabSlot content
        this.tabs = this.tabSlot.assignedNodes()
        this.tabs.forEach((child, index) => {
            child.classList.add('tab-content')
            child.dataset.tab = index

            // create li
            const li = document.createElement('li')
            li.classList.add(this.getAttribute('tab-link-class'))

            // create tab link
            const a = document.createElement('a')
            a.href = '#'
            a.innerText = child.dataset.tabTitle
            a.dataset.tab = index
            a.addEventListener('click', this.onTabClick.bind(this))
            li.appendChild(a)

            //append li in nav
            this.tabList.appendChild(li)

            // first tab is active
            if (index === 0) {
                child.classList.add('active')
                a.classList.add('active')
            }
        })

        // get navslot content
        if (this.navSlot.assignedNodes()[0]) {
            this.navSlot.assignedNodes()[0].appendChild(this.tabList)
        }
        else {
            this.navSlot.appendChild(this.tabList)
        }

    }

    onTabClick(e) {
        e.preventDefault()
        this.currentTab = e.target.dataset.tab

        // update tabs
        this.tabs.forEach(child => {
            child.classList.remove('active')
            if (child.dataset.tab == this.currentTab) {
                child.classList.add('active')
            }
        })

        // update links
        this.tabList.querySelectorAll('a').forEach(a => {
            a.classList.remove('active')
            if (a.dataset.tab == this.currentTab) {
                a.classList.add('active')
            }
        })

    }


}