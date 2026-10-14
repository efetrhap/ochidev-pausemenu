let isOpen = false;
let confirmTimeout = null;

function formatCurrency(amount) {
    const num = parseInt(amount, 10) || 0;
    return '$' + num.toLocaleString('en-US');
}

function resetDisconnectConfirm() {
    clearTimeout(confirmTimeout);
    confirmTimeout = null;
    $('#btn_disconnect .nav-card-confirm').hide();
    $('#btn_disconnect .nav-card-normal').show();
}

$(function() {
    $('#pause_wrapper').hide();

    $('#btn_resume').click(function() {
        $.post(`https://${GetParentResourceName()}/resume`, JSON.stringify({}));
    });

    $('#btn_map').click(function() {
        $.post(`https://${GetParentResourceName()}/map`, JSON.stringify({}));
    });

    $('#btn_settings').click(function() {
        $.post(`https://${GetParentResourceName()}/settings`, JSON.stringify({}));
    });

    $('#btn_disconnect .nav-card-normal').click(function(e) {
        e.stopPropagation();
        $('#btn_disconnect .nav-card-normal').hide();
        $('#btn_disconnect .nav-card-confirm').fadeIn(150);
        clearTimeout(confirmTimeout);
        confirmTimeout = setTimeout(resetDisconnectConfirm, 5000);
    });

    $('#btn_confirm_disconnect').click(function(e) {
        e.stopPropagation();
        resetDisconnectConfirm();
        $.post(`https://${GetParentResourceName()}/disconnect`, JSON.stringify({}));
    });

    $('#btn_cancel_disconnect').click(function(e) {
        e.stopPropagation();
        resetDisconnectConfirm();
    });

    $(document).keydown(function(e) {
        if (!isOpen) return;
        if (e.key === 'Escape') {
            $.post(`https://${GetParentResourceName()}/resume`, JSON.stringify({}));
        }
    });
});

window.addEventListener('message', function(event) {
    const item = event.data;

    if (item.action === 'open') {
        isOpen = true;
        resetDisconnectConfirm();
        const d = item.data || {};
        const labels = item.labels || {};

        if (d.name) $('#player_name').text(d.name);
        if (d.time) $('#server_time').text(d.time);
        if (d.job) $('#player_job').text(d.job);
        $('#player_cash').text(formatCurrency(d.cash));
        $('#player_bank').text(formatCurrency(d.bank));

        if (labels.Resume) $('#label_resume').text(labels.Resume);
        if (labels.Map) $('#label_map').text(labels.Map);
        if (labels.Settings) $('#label_settings').text(labels.Settings);
        if (labels.Disconnect) $('#label_disconnect').text(labels.Disconnect);
        if (labels.Cash) $('#label_cash').text(labels.Cash);
        if (labels.Bank) $('#label_bank').text(labels.Bank);

        $('#pause_wrapper').fadeIn(250);
    } else if (item.action === 'close') {
        isOpen = false;
        resetDisconnectConfirm();
        $('#pause_wrapper').hide();
    }
});
