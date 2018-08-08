<?php

namespace Bktech\Frontend\Block;

use Magento\Framework\View\Element\Html\Link;

class LinkWithClass extends Link
{
    protected function _toHtml()
    {
        if (false != $this->getTemplate()) {
            return parent::_toHtml();
        }

        return '<li class="'.$this->getData('container_class').'"><a '.$this->getLinkAttributes().' >'.$this->escapeHtml($this->getLabel()).'</a></li>';
    }

}
