import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getActiveReports from '@salesforce/apex/PowerBIreportsController.getActiveReports';

export default class PowerBiReportList extends LightningElement {
    @api initialSelection;

    searchTerm = '';
    selectedName = null;
    iframeKey = 0;
    isLoading = true;

    reportMap = {};

    // ===== Lifecycle =====
    connectedCallback() {
        this.loadReports();
    }

    // ===== Data load =====
    loadReports() {
        this.isLoading = true;
        return getActiveReports()
        .then((data) => {
            const map = {};
            (data || []).forEach((r) => {
            if (r && r.name && r.url) {
                map[r.name] = r.url;
            }
            });
            this.reportMap = map;

            const names = this._namesFromMap();

            if (!this.selectedName) {
            this.selectedName =
                this.initialSelection && this.reportMap[this.initialSelection]
                ? this.initialSelection
                : (names[0] || null);
            } else if (!this.reportMap[this.selectedName]) {
            this.selectedName = names[0] || null;
            }
        })
        .catch((error) => {
            this.reportMap = {};
            this.selectedName = null;
            this._toast('Error', this._errMsg(error), 'error');
        })
        .finally(() => {
            this.isLoading = false;
        });
    }

    @api
    refreshList() {
        return this.loadReports();
    }

    // ===== Getters/Helpers =====
    _namesFromMap() {
        return Object.keys(this.reportMap || {});
    }

    get reportCount() {
        return this._namesFromMap().length;
    }

    get filteredNames() {
        const t = (this.searchTerm || '').toLowerCase();
        return this._namesFromMap().filter((n) => !t || n.toLowerCase().includes(t));
    }

    get computedSrc() {
        const base = this.reportMap?.[this.selectedName];
        if (!base) return null;
        const sep = base.includes('?') ? '&' : '?';
        return `${base}${sep}ts=${this.iframeKey}`;
    }

    // ===== Handlers =====
    handleSelect(event) {
        this.selectedName = event.detail.name;
    }

    handleSearchChange(event) {
        this.searchTerm = event.target.value;
    }

    reload() {
        this.iframeKey += 1;
    }

    openInNewTab() {
        const url = this.reportMap?.[this.selectedName];
        if (url) window.open(url, '_blank');
    }

    // ===== Utils =====
    _errMsg(error) {
        return Array.isArray(error?.body)
        ? error.body.map((e) => e.message).join(' ')
        : error?.body?.message || error?.message || 'Error';
    }

    _toast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}