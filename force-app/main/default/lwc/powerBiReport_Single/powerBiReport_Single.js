import { LightningElement, api } from 'lwc';

export default class PowerBiReport_Single extends LightningElement {
    @api reportUrl;
    @api reportName = 'Power BI Report';

    iframeKey = 0;
    isLoading = false;

    // ===== Getters =====
    get computedSrc() {
        if (!this.reportUrl) return null;
        const sep = this.reportUrl.includes('?') ? '&' : '?';
        return `${this.reportUrl}${sep}ts=${this.iframeKey}`;
    }

    get hasReport() {
        return !!this.reportUrl;
    }

    // ===== Lifecycle =====
    renderedCallback() {
        if (this.reportUrl && !this.isLoading) {
            this.isLoading = true;
        }
    }

    // ===== Handlers =====
    handleIframeLoad() {
        this.isLoading = false;
    }

    reload() {
        this.isLoading = true;
        this.iframeKey += 1;
    }

    openInNewTab() {
        if (this.reportUrl) {
            window.open(this.reportUrl, '_blank');
        }
    }
}
